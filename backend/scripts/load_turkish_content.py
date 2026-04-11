"""
Türkçe markdown ders dosyalarını okuyup DB'ye yükler.

Dosya adı formatı: A1_Konu01.md, A1_Konu02.md, B1_Konu03.md ...
Her dosya bir konuya ait 2 dersi (X.1 ve X.2) içerir.

Kullanım:
    cd backend

    # Tüm dosyaları yükle:
    venv/Scripts/python scripts/load_turkish_content.py

    # Sadece belirli bir seviye:
    venv/Scripts/python scripts/load_turkish_content.py --level A1

    # Sadece belirli bir dosya:
    venv/Scripts/python scripts/load_turkish_content.py --file content/turkish/A1_Konu01.md

    # Önce ne yapacağını göster, DB'ye yazma:
    venv/Scripts/python scripts/load_turkish_content.py --dry-run
"""
import sys, os, re, json, argparse, glob
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

CONTENT_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "content", "turkish")

# Ders başlığı pattern: "# A1 Konu 1.1: Başlık (İngilizce Başlık)"
LESSON_HEADING = re.compile(
    r"^#\s+([A-C][12])\s+Konu\s+(\d+)\.(\d+):\s+(.+?)(?:\s*\(.+\))?\s*$",
    re.MULTILINE
)


# ─────────────────────────────────────────────────────────────
# PARSER
# ─────────────────────────────────────────────────────────────
def parse_file(filepath: str) -> dict:
    """
    Dosyayı okur, derslere böler ve yapılandırılmış veri döndürür.

    Dönüş:
    {
        "level": "A1",
        "topic_order": 1,
        "topic_title": "...",
        "topic_description": "...",
        "topic_rules": "...",
        "topic_examples": ["...", ...],
        "lessons": [
            {"title": "...", "lesson_type": "...", "content": "..."},
            ...
        ]
    }
    """
    with open(filepath, encoding="utf-8") as f:
        raw = f.read()

    # Dosyadaki tüm ders başlıklarını bul
    matches = list(LESSON_HEADING.finditer(raw))
    if not matches:
        raise ValueError(f"❌ Hiç ders başlığı bulunamadı: {filepath}\n"
                         f"   Beklenen format: '# A1 Konu 1.1: Başlık'")

    level = matches[0].group(1)           # "A1"
    topic_order = int(matches[0].group(2)) # 1

    # Her ders bloğunu ayır
    lessons = []
    for i, m in enumerate(matches):
        start = m.start()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(raw)
        block = raw[start:end].strip()
        lesson_title = m.group(4).strip()
        lessons.append({
            "lesson_number": int(m.group(3)),
            "title": lesson_title,
            "lesson_type": _infer_lesson_type(lesson_title, block),
            "content": block,
            "description": _extract_section(block, "Konu Açıklaması"),
        })

    # İlk dersten konu bilgilerini çıkar
    first_block = lessons[0]["content"]
    topic_title = _infer_topic_title(lessons[0]["title"])
    topic_desc  = lessons[0]["description"] or ""
    topic_rules = _extract_section(first_block, "Temel Kural")
    topic_examples = _extract_examples(first_block)

    return {
        "level": level,
        "topic_order": topic_order,
        "topic_title": topic_title,
        "topic_description": topic_desc,
        "topic_rules": topic_rules,
        "topic_examples": json.dumps(topic_examples, ensure_ascii=False),
        "lessons": [
            {"title": l["title"], "lesson_type": l["lesson_type"],
             "content": l["content"], "description": l["description"]}
            for l in sorted(lessons, key=lambda x: x["lesson_number"])
        ],
    }


def _extract_section(text: str, section_keyword: str) -> str:
    """## ile başlayan bir bölümün içeriğini çıkar."""
    pattern = re.compile(
        r"##\s+[^#\n]*" + re.escape(section_keyword) + r"[^\n]*\n(.*?)(?=\n##|\Z)",
        re.DOTALL | re.IGNORECASE
    )
    m = pattern.search(text)
    return m.group(1).strip() if m else ""


def _extract_examples(text: str) -> list:
    """## Örnek Cümleler bölümündeki ilk 3 cümleyi liste olarak döndür."""
    section = _extract_section(text, "Örnek Cümleler")
    lines = [
        re.sub(r"^\d+\.\s*\*?\*?", "", line).strip().split("(")[0].strip()
        for line in section.splitlines()
        if re.match(r"^\d+\.", line.strip())
    ]
    return [l for l in lines if l][:3]


def _infer_lesson_type(title: str, content: str) -> str:
    """Ders içeriğinden lesson_type tahmin et."""
    lower = (title + content[:200]).lower()
    if any(k in lower for k in ["kural", "yapı", "gramer", "grammar", "ekler", "zaman", "kip", "fiil"]):
        return "grammar"
    if any(k in lower for k in ["kelime", "vocabulary", "sözcük", "ifade"]):
        return "vocabulary"
    return "vocabulary"


def _infer_topic_title(first_lesson_title: str) -> str:
    """1.1 ders başlığından konu başlığı türet — alt başlığı kaldır."""
    # "Türk Alfabesi ve Sesletim" → aynı
    # "29 Harf ve Sesletim Rehberi" → "29 Harf ve Sesletim Rehberi"
    return first_lesson_title.strip()


# ─────────────────────────────────────────────────────────────
# SEEDER
# ─────────────────────────────────────────────────────────────
LEVEL_META = {
    "A1": {"display_name": "Başlangıç", "order_index": 1,
           "description": "Günlük temel iletişim, 300–500 kelime."},
    "A2": {"display_name": "Temel",     "order_index": 2,
           "description": "Aşina olunan konularda basit iletişim, 800–1200 kelime."},
    "B1": {"display_name": "Orta Öncesi", "order_index": 3,
           "description": "Bildik konularda akıcı iletişim, 1500–2500 kelime."},
    "B2": {"display_name": "Orta",      "order_index": 4,
           "description": "Karmaşık konularda akıcı iletişim, 3000–4000 kelime."},
    "C1": {"display_name": "İleri",     "order_index": 5,
           "description": "Soyut konularda esnek iletişim, 5000+ kelime."},
    "C2": {"display_name": "Ustalık",   "order_index": 6,
           "description": "Anadil konuşucusu düzeyinde anlama ve ifade."},
}


def seed_from_parsed(db, parsed: dict, dry_run: bool = False):
    from app.models.models import LanguageLevel, GrammarTopic, Lesson

    level = parsed["level"]
    meta  = LEVEL_META[level]

    # LanguageLevel — yoksa oluştur
    lang_level = db.query(LanguageLevel).filter_by(language="turkish", level=level).first()
    if not lang_level:
        if dry_run:
            print(f"   [DRY] LanguageLevel oluşturulacak: turkish / {level}")
        else:
            lang_level = LanguageLevel(
                language="turkish",
                level=level,
                display_name=meta["display_name"],
                description=meta["description"],
                order_index=meta["order_index"],
            )
            db.add(lang_level)
            db.flush()

    # Konu zaten var mı?
    if not dry_run:
        existing_topic = db.query(GrammarTopic).filter_by(
            language_level_id=lang_level.id,
            title=parsed["topic_title"]
        ).first()
        if existing_topic:
            print(f"   ⏭️  Konu zaten var: '{parsed['topic_title']}' — atlanıyor.")
            return

    if dry_run:
        print(f"   [DRY] GrammarTopic: '{parsed['topic_title']}' (order={parsed['topic_order']})")
        for l in parsed["lessons"]:
            print(f"         Ders [{l['lesson_type']}]: {l['title']}")
        return

    topic = GrammarTopic(
        language_level_id=lang_level.id,
        language="turkish",
        level=level,
        title=parsed["topic_title"],
        description=parsed["topic_description"],
        order_index=parsed["topic_order"],
        rules=parsed["topic_rules"],
        examples=parsed["topic_examples"],
    )
    db.add(topic)
    db.flush()

    for i, lesson_data in enumerate(parsed["lessons"]):
        lesson = Lesson(
            grammar_topic_id=topic.id,
            language="turkish",
            level=level,
            title=lesson_data["title"],
            description=lesson_data["description"],
            lesson_type=lesson_data["lesson_type"],
            content=lesson_data["content"],
            order_index=i + 1,
        )
        db.add(lesson)

    db.commit()
    print(f"   ✅  '{parsed['topic_title']}' — {len(parsed['lessons'])} ders eklendi.")


# ─────────────────────────────────────────────────────────────
# ANA FONKSİYON
# ─────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description="Türkçe markdown ders içeriğini DB'ye yükle.")
    parser.add_argument("--level",   help="Sadece bu seviyeyi yükle (A1, B2, ...)")
    parser.add_argument("--file",    help="Sadece bu dosyayı yükle")
    parser.add_argument("--dry-run", action="store_true", help="DB'ye yazmadan önizle")
    args = parser.parse_args()

    if not os.path.isdir(CONTENT_DIR):
        print(f"❌ İçerik klasörü bulunamadı: {CONTENT_DIR}")
        print(f"   Klasörü oluştur ve .md dosyalarını ekle.")
        sys.exit(1)

    # Dosya listesi belirle
    if args.file:
        files = [args.file]
    elif args.level:
        lvl = args.level.upper()
        files = sorted(
            glob.glob(os.path.join(CONTENT_DIR, "**", f"*{lvl}*.md"), recursive=True) +
            glob.glob(os.path.join(CONTENT_DIR, "**", f"*{lvl}*.txt"), recursive=True) +
            glob.glob(os.path.join(CONTENT_DIR, f"*{lvl}*.md")) +
            glob.glob(os.path.join(CONTENT_DIR, f"*{lvl}*.txt"))
        )
        files = sorted(set(files))
    else:
        files = sorted(
            glob.glob(os.path.join(CONTENT_DIR, "**", "*.md"), recursive=True) +
            glob.glob(os.path.join(CONTENT_DIR, "**", "*.txt"), recursive=True)
        )

    if not files:
        print(f"❌ Hiç .md dosyası bulunamadı: {CONTENT_DIR}")
        sys.exit(1)

    print(f"📂 {len(files)} dosya bulundu.\n")

    from app.database import SessionLocal
    db = SessionLocal()

    try:
        for filepath in files:
            fname = os.path.basename(filepath)
            print(f"📄 {fname}")
            try:
                parsed = parse_file(filepath)
                seed_from_parsed(db, parsed, dry_run=args.dry_run)
            except Exception as e:
                print(f"   ❌ HATA: {e}")
    finally:
        db.close()

    print("\n✔️  Tamamlandı.")


if __name__ == "__main__":
    main()
