"""
A1 ders içeriği seed scripti — statik, Gemini gerektirmez.
3 dil × 6 konu × 2 ders = 36 ders

Kullanım:
    cd backend
    venv/Scripts/python scripts/seed_content.py
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.database import SessionLocal
from app.models.models import LanguageLevel, GrammarTopic, Lesson

# ──────────────────────────────────────────────────────────────
# ENGLISH A1
# ──────────────────────────────────────────────────────────────
ENGLISH_A1 = {
    "language": "english",
    "level": "A1",
    "display_name": "Beginner",
    "description": "Basic communication, everyday vocabulary (500–800 words), simple sentences.",
    "order_index": 1,
    "topics": [
        {
            "title": "Greetings & Introductions",
            "description": "Learn how to say hello, goodbye, and introduce yourself in English.",
            "order": 1,
            "rules": "- Use 'Hello' or 'Hi' informally\n- 'Good morning/afternoon/evening' for formal greetings\n- 'My name is...' or 'I'm...' to introduce yourself\n- 'Nice to meet you' when meeting someone",
            "examples": '["Hello! My name is Sarah.", "Hi, I\'m Tom. Nice to meet you!", "Good morning! How are you?"]',
            "lessons": [
                {
                    "title": "Hello! Basic Greetings",
                    "description": "Learn essential greetings for every part of the day.",
                    "lesson_type": "vocabulary",
                    "content": """# Hello! Basic Greetings

## Key Vocabulary

| English | Meaning |
|---------|---------|
| Hello / Hi | Merhaba |
| Good morning | Günaydın |
| Good afternoon | İyi öğleden sonralar |
| Good evening | İyi akşamlar |
| Good night | İyi geceler |
| Goodbye / Bye | Hoşça kal / Görüşürüz |
| See you later | Sonra görüşürüz |
| How are you? | Nasılsın? |
| Fine, thank you | İyiyim, teşekkürler |
| Please | Lütfen |
| Thank you | Teşekkür ederim |
| You're welcome | Rica ederim |

## Example Sentences

- **A:** Hello! How are you?
- **B:** Hi! I'm fine, thank you. And you?
- **A:** I'm great, thanks!

---
- **A:** Good morning!
- **B:** Good morning! Have a nice day.

## Practice Tip
Try greeting someone in English every morning. Start with "Good morning!" 🌞
""",
                },
                {
                    "title": "What's Your Name?",
                    "description": "Learn to introduce yourself and ask others' names.",
                    "lesson_type": "grammar",
                    "content": """# What's Your Name?

## Introducing Yourself

Use these patterns to introduce yourself:

| Pattern | Example |
|---------|---------|
| My name is [name]. | My name is Emma. |
| I'm [name]. | I'm Jack. |
| What's your name? | (Adın ne?) |
| Nice to meet you! | (Tanıştığımıza memnun oldum!) |

## Key Vocabulary

| English | Türkçe |
|---------|--------|
| name | isim |
| age | yaş |
| country | ülke |
| city | şehir |
| student | öğrenci |
| teacher | öğretmen |
| from | -den / -dan |

## Example Dialogue

**A:** Hello! What's your name?
**B:** Hi! My name is Maria. What's your name?
**A:** I'm James. Nice to meet you, Maria!
**B:** Nice to meet you too, James. Where are you from?
**A:** I'm from England. And you?
**B:** I'm from Turkey.

## Useful Phrases
- I'm from **[country]** → Ben **[ülke]**'den/danım
- I live in **[city]** → **[şehir]**'de yaşıyorum
- I'm a **[job]** → Ben bir **[meslek]**im

## Practice Tip
Write 3 sentences about yourself: your name, where you're from, and what you do. 📝
""",
                },
            ],
        },
        {
            "title": "Numbers & Counting",
            "description": "Master numbers from 1 to 100 in English.",
            "order": 2,
            "rules": "- Numbers 1-12 are unique words\n- 13-19 end in '-teen'\n- 20, 30, 40... end in '-ty'\n- Compound numbers: twenty-one, thirty-five",
            "examples": '["I have two cats.", "She is twenty-three years old.", "There are fifteen students."]',
            "lessons": [
                {
                    "title": "Numbers 1–20",
                    "description": "Learn to count from 1 to 20 in English.",
                    "lesson_type": "vocabulary",
                    "content": """# Numbers 1–20

## The Numbers

| Number | Word | Türkçe |
|--------|------|--------|
| 1 | one | bir |
| 2 | two | iki |
| 3 | three | üç |
| 4 | four | dört |
| 5 | five | beş |
| 6 | six | altı |
| 7 | seven | yedi |
| 8 | eight | sekiz |
| 9 | nine | dokuz |
| 10 | ten | on |
| 11 | eleven | on bir |
| 12 | twelve | on iki |
| 13 | thirteen | on üç |
| 14 | fourteen | on dört |
| 15 | fifteen | on beş |
| 16 | sixteen | on altı |
| 17 | seventeen | on yedi |
| 18 | eighteen | on sekiz |
| 19 | nineteen | on dokuz |
| 20 | twenty | yirmi |

## Example Sentences
- I have **five** books.
- She is **twelve** years old.
- There are **fifteen** students in the class.
- My phone number is **zero-seven** ...

## Practice Tip
Count objects around you in English — chairs, windows, books! 🔢
""",
                },
                {
                    "title": "Numbers 21–100",
                    "description": "Count from 21 to 100 and use numbers in sentences.",
                    "lesson_type": "vocabulary",
                    "content": """# Numbers 21–100

## Tens

| Number | Word | Türkçe |
|--------|------|--------|
| 20 | twenty | yirmi |
| 30 | thirty | otuz |
| 40 | forty | kırk |
| 50 | fifty | elli |
| 60 | sixty | altmış |
| 70 | seventy | yetmiş |
| 80 | eighty | seksen |
| 90 | ninety | doksan |
| 100 | one hundred | yüz |

## Compound Numbers
Combine tens + ones with a hyphen:
- 21 → **twenty-one**
- 35 → **thirty-five**
- 47 → **forty-seven**
- 99 → **ninety-nine**

## Example Sentences
- I am **twenty-three** years old.
- The book costs **forty-five** dollars.
- There are **one hundred** days until the exam.

## Practice Tip
Say your phone number, birthday year, and address number in English! 📞
""",
                },
            ],
        },
        {
            "title": "Colors & Shapes",
            "description": "Describe the world around you with colors and shapes.",
            "order": 3,
            "rules": "- Adjectives come before nouns: 'a red car'\n- Colors can also be nouns: 'I like red'\n- Common question: 'What color is it?'",
            "examples": '["The sky is blue.", "I have a red car.", "What color is your bag?"]',
            "lessons": [
                {
                    "title": "Basic Colors",
                    "description": "Learn all the essential colors in English.",
                    "lesson_type": "vocabulary",
                    "content": """# Basic Colors

## The Colors

| English | Türkçe | Example |
|---------|--------|---------|
| red | kırmızı | a red apple |
| blue | mavi | the blue sky |
| green | yeşil | green grass |
| yellow | sarı | a yellow banana |
| orange | turuncu | an orange fruit |
| purple | mor | purple flowers |
| pink | pembe | a pink dress |
| white | beyaz | white snow |
| black | siyah | a black cat |
| grey / gray | gri | grey clouds |
| brown | kahverengi | brown earth |

## How to Use Colors
Put the color **before** the noun:
- a **red** car
- the **blue** ocean
- a **green** tree

## Questions & Answers
- **What color is it?** → It's **blue**.
- **What's your favorite color?** → My favorite color is **green**.

## Example Sentences
- The apple is **red**.
- I wear a **blue** shirt today.
- Her eyes are **green**.

## Practice Tip
Look around the room and name 5 things with their colors! 🎨
""",
                },
                {
                    "title": "Common Shapes",
                    "description": "Learn to identify and describe basic shapes.",
                    "lesson_type": "vocabulary",
                    "content": """# Common Shapes

## Basic Shapes

| English | Türkçe |
|---------|--------|
| circle | daire |
| square | kare |
| rectangle | dikdörtgen |
| triangle | üçgen |
| star | yıldız |
| heart | kalp |
| diamond | elmas / baklava |
| oval | oval |

## Describing Shapes
- **It's a circle.** → Bu bir dairedir.
- **It's square.** → Kare şeklinde.
- **What shape is it?** → Şekli nedir?

## Colors + Shapes Together
- a **red circle** → kırmızı bir daire
- a **blue square** → mavi bir kare
- a **yellow triangle** → sarı bir üçgen

## Example Sentences
- A pizza is a **circle**.
- A book is a **rectangle**.
- A traffic sign is a **triangle**.

## Practice Tip
Draw 5 shapes and write their names and colors in English! ✏️
""",
                },
            ],
        },
        {
            "title": "The Verb 'To Be'",
            "description": "Master the most important verb in English: am, is, are.",
            "order": 4,
            "rules": "- I am / I'm\n- He/She/It is / He's/She's/It's\n- You/We/They are / You're/We're/They're\n- Negative: am not, isn't, aren't\n- Question: Am I? Is he? Are they?",
            "examples": '["I am a student.", "She is happy.", "They are teachers.", "Are you from Turkey?"]',
            "lessons": [
                {
                    "title": "Am / Is / Are — Positive",
                    "description": "Learn the three forms of 'to be' and when to use each.",
                    "lesson_type": "grammar",
                    "content": """# Am / Is / Are

## The Verb "To Be" — Positive Form

| Subject | To Be | Short Form | Türkçe |
|---------|-------|------------|--------|
| I | am | I'm | Ben -im |
| You | are | You're | Sen -sin |
| He | is | He's | O -dır (erkek) |
| She | is | She's | O -dır (kadın) |
| It | is | It's | O -dır (nesne) |
| We | are | We're | Biz -iz |
| You (plural) | are | You're | Siz -siniz |
| They | are | They're | Onlar -dır |

## Example Sentences
- **I'm** a student. (Ben öğrenciyim.)
- **She's** happy. (O mutlu.)
- **We're** from Turkey. (Biz Türkiye'denim.)
- **It's** a cat. (Bu bir kedi.)
- **They're** teachers. (Onlar öğretmen.)

## Common Uses
1. **Describing people:** She **is** tall.
2. **Nationality:** I **am** Turkish.
3. **Profession:** He **is** a doctor.
4. **Location:** We **are** in Istanbul.
5. **Feelings:** They **are** tired.

## Practice Tip
Write 5 sentences about yourself and your family using am/is/are! ✍️
""",
                },
                {
                    "title": "Negative & Questions with To Be",
                    "description": "Learn to make negative sentences and ask questions.",
                    "lesson_type": "grammar",
                    "content": """# Negative & Questions with "To Be"

## Negative Form

Add **not** after am/is/are:

| Positive | Negative | Short Form |
|----------|----------|------------|
| I am | I am not | I'm not |
| He/She/It is | He/She/It is not | isn't |
| You/We/They are | You/We/They are not | aren't |

### Examples
- I **am not** tired. → I'**m not** tired.
- She **is not** a teacher. → She **isn't** a teacher.
- They **are not** from Spain. → They **aren't** from Spain.

## Question Form

Move am/is/are to the front:

| Statement | Question |
|-----------|----------|
| You are a student. | **Are** you a student? |
| She is happy. | **Is** she happy? |
| They are here. | **Are** they here? |

### Short Answers
- **Are you a student?** → Yes, I **am**. / No, I **am not**.
- **Is he from France?** → Yes, he **is**. / No, he **isn't**.

## Practice Dialogue
**A:** Are you a teacher?
**B:** No, I'm not. I'm a student.
**A:** Is she your friend?
**B:** Yes, she is. She's my classmate.

## Practice Tip
Make 3 questions and 3 negative sentences about yourself! ❓
""",
                },
            ],
        },
        {
            "title": "Daily Routine & Time",
            "description": "Talk about your daily schedule and tell the time.",
            "order": 5,
            "rules": "- 'What time is it?' to ask the time\n- 'It's [number] o'clock' for exact hours\n- 'at' + time: I wake up at 7 o'clock\n- Common routine verbs: wake up, eat, go, sleep",
            "examples": '["I wake up at 7 o\'clock.", "It\'s half past three.", "She goes to school at 8 AM."]',
            "lessons": [
                {
                    "title": "What Time Is It?",
                    "description": "Learn to tell and ask for the time in English.",
                    "lesson_type": "vocabulary",
                    "content": """# What Time Is It?

## Asking & Telling the Time

**Question:** What time is it? / What's the time?
**Answer:** It's [time].

## Time Expressions

| Time | English | Türkçe |
|------|---------|--------|
| 3:00 | It's three o'clock | Saat üç |
| 3:15 | It's quarter past three | Üçü çeyrek geçiyor |
| 3:30 | It's half past three | Üç buçuk |
| 3:45 | It's quarter to four | Dörde çeyrek var |
| 8:00 AM | eight in the morning | Sabah sekiz |
| 12:00 | noon / midday | öğlen |
| 6:00 PM | six in the evening | akşam altı |
| 12:00 AM | midnight | gece yarısı |

## Time Vocabulary

| English | Türkçe |
|---------|--------|
| morning | sabah |
| afternoon | öğleden sonra |
| evening | akşam |
| night | gece |
| today | bugün |
| tomorrow | yarın |
| yesterday | dün |

## Example Sentences
- **What time is it?** → It's **ten o'clock**.
- I go to bed at **eleven** at night.
- The class starts at **nine** in the morning.

## Practice Tip
Set 3 alarms and write what time they are in English! ⏰
""",
                },
                {
                    "title": "My Daily Routine",
                    "description": "Describe what you do every day using common verbs.",
                    "lesson_type": "reading",
                    "content": """# My Daily Routine

## Routine Verbs

| English | Türkçe |
|---------|--------|
| wake up | uyanmak |
| get up | kalkmak |
| take a shower | duş almak |
| get dressed | giyinmek |
| eat breakfast | kahvaltı etmek |
| go to work/school | işe/okula gitmek |
| have lunch | öğle yemeği yemek |
| come home | eve gelmek |
| eat dinner | akşam yemeği yemek |
| watch TV | TV izlemek |
| go to bed | yatmak |
| sleep | uyumak |

## A Sample Daily Routine

> I **wake up** at 7 o'clock. I **take a shower** and **get dressed**.
> At 7:30, I **eat breakfast**. I usually have eggs and tea.
> I **go to school** at 8 o'clock.
> At 12:30, I **have lunch** with my friends.
> I **come home** at 4 PM.
> In the evening, I **do homework** and **watch TV**.
> I **go to bed** at 10:30 at night.

## Time Connectors

| Word | Use |
|------|-----|
| first | ilk önce |
| then | sonra |
| after that | ondan sonra |
| finally | son olarak |
| at [time] | saat [saat]'de |
| in the morning | sabahleyin |

## Practice Tip
Write YOUR daily routine using at least 6 verbs and time expressions! 📅
""",
                },
            ],
        },
        {
            "title": "Food & Drinks",
            "description": "Name common foods and drinks, and order at a café.",
            "order": 6,
            "rules": "- 'I like/love/hate + noun' for preferences\n- 'I would like...' for polite ordering\n- Countable: an apple, two bananas\n- Uncountable: some water, some bread",
            "examples": '["I like coffee.", "Can I have a sandwich, please?", "Do you have orange juice?"]',
            "lessons": [
                {
                    "title": "Common Foods & Drinks",
                    "description": "Learn the names of everyday foods and drinks.",
                    "lesson_type": "vocabulary",
                    "content": """# Common Foods & Drinks

## Food

| English | Türkçe |
|---------|--------|
| bread | ekmek |
| rice | pirinç |
| pasta | makarna |
| meat | et |
| chicken | tavuk |
| fish | balık |
| egg | yumurta |
| cheese | peynir |
| salad | salata |
| soup | çorba |
| apple | elma |
| banana | muz |
| orange | portakal |
| tomato | domates |
| potato | patates |

## Drinks

| English | Türkçe |
|---------|--------|
| water | su |
| tea | çay |
| coffee | kahve |
| milk | süt |
| juice | meyve suyu |
| soda | gazoz |

## Expressing Preferences

- I **like** tea. ✓
- I **love** chocolate! ❤️
- I **don't like** onions. ✗
- I **hate** bitter food. 😣

## Example Sentences
- I **eat** bread and eggs for breakfast.
- She **drinks** coffee every morning.
- Do you **like** pizza?

## Practice Tip
Write down everything you eat today in English! 🍽️
""",
                },
                {
                    "title": "At the Café",
                    "description": "Practice ordering food and drinks at a café.",
                    "lesson_type": "dialogue",
                    "content": """# At the Café ☕

## Useful Phrases

| English | Türkçe |
|---------|--------|
| Can I help you? | Size yardımcı olabilir miyim? |
| I would like... | ...istiyorum / ...alabilir miyim |
| Can I have...? | ...alabilir miyim? |
| What would you like? | Ne alırsınız? |
| How much is it? | Ne kadar? |
| Here you are. | Buyurun. |
| Thank you! | Teşekkürler! |
| Enjoy your meal! | Afiyet olsun! |

## Dialogue: Ordering at a Café

**Waiter:** Good morning! Can I help you?
**Customer:** Good morning! I would like a coffee, please.
**Waiter:** Of course. Small, medium, or large?
**Customer:** Medium, please. And can I have a sandwich?
**Waiter:** Sure! What kind? We have cheese and chicken.
**Customer:** Cheese, please.
**Waiter:** That's one medium coffee and one cheese sandwich. Anything else?
**Customer:** No, thank you. How much is it?
**Waiter:** It's seven dollars.
**Customer:** Here you are.
**Waiter:** Thank you! Here you are. Enjoy!
**Customer:** Thank you!

## Key Grammar: "Would like"
**I would like** = polite way to order
- I **would like** a tea. (✓ polite)
- I **want** a tea. (✓ but less polite)

## Practice Tip
Practice this dialogue with a friend or out loud — pretend you're at a café! ☕🥪
""",
                },
            ],
        },
    ],
}

# ──────────────────────────────────────────────────────────────
# GERMAN A1
# ──────────────────────────────────────────────────────────────
GERMAN_A1 = {
    "language": "german",
    "level": "A1",
    "display_name": "Anfänger",
    "description": "Grundlegende Kommunikation, einfacher Wortschatz (500–800 Wörter).",
    "order_index": 1,
    "topics": [
        {
            "title": "Begrüßungen & Vorstellungen",
            "description": "Lerne, wie man auf Deutsch grüßt und sich vorstellt.",
            "order": 1,
            "rules": "- 'Hallo' / 'Hi' für informelle Begrüßungen\n- 'Guten Morgen/Tag/Abend' für formelle Situationen\n- 'Ich heiße...' oder 'Mein Name ist...' zur Vorstellung\n- 'Wie heißt du?' (informell) / 'Wie heißen Sie?' (formell)",
            "examples": '["Hallo! Ich heiße Anna.", "Guten Morgen! Wie geht es Ihnen?", "Freut mich, dich kennenzulernen!"]',
            "lessons": [
                {
                    "title": "Hallo! Grundlegende Begrüßungen",
                    "description": "Lerne die wichtigsten Begrüßungsformeln auf Deutsch.",
                    "lesson_type": "vocabulary",
                    "content": """# Hallo! Grundlegende Begrüßungen

## Wichtige Wörter

| Deutsch | Türkçe |
|---------|--------|
| Hallo / Guten Tag | Merhaba |
| Guten Morgen | Günaydın |
| Guten Abend | İyi akşamlar |
| Gute Nacht | İyi geceler |
| Auf Wiedersehen | Hoşça kal |
| Tschüss | Görüşürüz |
| Wie geht es dir? | Nasılsın? |
| Mir geht es gut. | İyiyim. |
| Danke! | Teşekkürler! |
| Bitte! | Rica ederim / Lütfen |

## Beispieldialog (Örnek Diyalog)

**A:** Hallo! Wie geht es dir?
**B:** Hallo! Mir geht es gut, danke. Und dir?
**A:** Auch gut, danke!

---
**A:** Guten Morgen!
**B:** Guten Morgen! Einen schönen Tag!

## Formell vs. Informell
- **Informell (du):** Hallo! Wie geht es **dir**?
- **Formell (Sie):** Guten Tag! Wie geht es **Ihnen**?

## Übungstipp (Egzersiz İpucu)
Beginne jeden Morgen mit "Guten Morgen!" auf Deutsch! 🌞
""",
                },
                {
                    "title": "Wie heißt du?",
                    "description": "Lerne, dich auf Deutsch vorzustellen.",
                    "lesson_type": "grammar",
                    "content": """# Wie heißt du?

## Vorstellung (Tanışma)

| Satz | Türkçe |
|------|--------|
| Ich heiße [Name]. | Adım [İsim]. |
| Mein Name ist [Name]. | Adım [İsim]. |
| Wie heißt du? | Adın ne? |
| Wie heißen Sie? | Adınız ne? (resmi) |
| Woher kommst du? | Nerelisin? |
| Ich komme aus der Türkei. | Türkiye'denim. |
| Wo wohnst du? | Nerede yaşıyorsun? |
| Ich wohne in Berlin. | Berlin'de yaşıyorum. |
| Freut mich! | Tanıştığıma memnun oldum! |

## Beispieldialog

**A:** Hallo! Ich heiße Tom. Wie heißt du?
**B:** Hallo Tom! Ich heiße Lisa. Woher kommst du?
**A:** Ich komme aus England. Und du?
**B:** Ich komme aus der Türkei. Freut mich!
**A:** Mich auch!

## Zahlen für Alter
- Ich bin **zwanzig** Jahre alt. (20)
- Wie alt bist du? → Ich bin **fünfzehn**. (15)

## Übungstipp
Schreib drei Sätze über dich auf Deutsch! 📝
""",
                },
            ],
        },
        {
            "title": "Zahlen & Zählen",
            "description": "Lerne die deutschen Zahlen von 1 bis 100.",
            "order": 2,
            "rules": "- 1–12: einzigartige Wörter\n- 13–19: enden auf '-zehn'\n- 20, 30, 40...: enden auf '-zig' oder '-ßig'\n- Zusammengesetzte Zahlen: einundzwanzig (21)",
            "examples": '["Ich habe zwei Katzen.", "Sie ist dreiundzwanzig Jahre alt.", "Es gibt fünfzehn Studenten."]',
            "lessons": [
                {
                    "title": "Zahlen 1–20",
                    "description": "Lerne die deutschen Zahlen von 1 bis 20.",
                    "lesson_type": "vocabulary",
                    "content": """# Zahlen 1–20

## Die Zahlen

| Zahl | Deutsch | Türkçe |
|------|---------|--------|
| 1 | eins | bir |
| 2 | zwei | iki |
| 3 | drei | üç |
| 4 | vier | dört |
| 5 | fünf | beş |
| 6 | sechs | altı |
| 7 | sieben | yedi |
| 8 | acht | sekiz |
| 9 | neun | dokuz |
| 10 | zehn | on |
| 11 | elf | on bir |
| 12 | zwölf | on iki |
| 13 | dreizehn | on üç |
| 14 | vierzehn | on dört |
| 15 | fünfzehn | on beş |
| 16 | sechzehn | on altı |
| 17 | siebzehn | on yedi |
| 18 | achtzehn | on sekiz |
| 19 | neunzehn | on dokuz |
| 20 | zwanzig | yirmi |

## Beispielsätze
- Ich habe **fünf** Bücher.
- Sie ist **zwölf** Jahre alt.
- Es gibt **fünfzehn** Schüler in der Klasse.

## Übungstipp
Zähle die Objekte in deinem Zimmer auf Deutsch! 🔢
""",
                },
                {
                    "title": "Zahlen 21–100",
                    "description": "Lerne zusammengesetzte Zahlen und zähle bis 100.",
                    "lesson_type": "vocabulary",
                    "content": """# Zahlen 21–100

## Zehner

| Zahl | Deutsch | Türkçe |
|------|---------|--------|
| 20 | zwanzig | yirmi |
| 30 | dreißig | otuz |
| 40 | vierzig | kırk |
| 50 | fünfzig | elli |
| 60 | sechzig | altmış |
| 70 | siebzig | yetmiş |
| 80 | achtzig | seksen |
| 90 | neunzig | doksan |
| 100 | hundert | yüz |

## Zusammengesetzte Zahlen
Einheit + und + Zehner:
- 21 → **einundzwanzig**
- 35 → **fünfunddreißig**
- 47 → **siebenundvierzig**
- 99 → **neunundneunzig**

## Beispielsätze
- Ich bin **dreiundzwanzig** Jahre alt.
- Das Buch kostet **fünfundvierzig** Euro.
- Es gibt **hundert** Tage bis zur Prüfung.

## Übungstipp
Sag deine Telefonnummer und dein Geburtsjahr auf Deutsch! 📞
""",
                },
            ],
        },
        {
            "title": "Farben & Formen",
            "description": "Beschreibe die Welt um dich herum mit Farben und Formen.",
            "order": 3,
            "rules": "- Adjektive stehen vor dem Nomen: 'ein rotes Auto'\n- Adjektive können dekliniert werden\n- Frage: 'Welche Farbe hat...?'",
            "examples": '["Der Himmel ist blau.", "Ich habe ein rotes Auto.", "Welche Farbe hat deine Tasche?"]',
            "lessons": [
                {
                    "title": "Grundfarben",
                    "description": "Lerne alle wichtigen Farben auf Deutsch.",
                    "lesson_type": "vocabulary",
                    "content": """# Grundfarben

## Die Farben

| Deutsch | Türkçe | Beispiel |
|---------|--------|---------|
| rot | kırmızı | ein roter Apfel |
| blau | mavi | der blaue Himmel |
| grün | yeşil | grünes Gras |
| gelb | sarı | eine gelbe Banane |
| orange | turuncu | eine orange Frucht |
| lila / violett | mor | lila Blumen |
| rosa | pembe | ein rosa Kleid |
| weiß | beyaz | weißer Schnee |
| schwarz | siyah | eine schwarze Katze |
| grau | gri | graue Wolken |
| braun | kahverengi | braune Erde |

## Farben verwenden
Farbe steht **vor** dem Nomen:
- ein **rotes** Auto
- der **blaue** Ozean
- ein **grüner** Baum

## Beispielsätze
- Der Apfel ist **rot**.
- Ich trage ein **blaues** Hemd.
- Ihre Augen sind **grün**.

## Fragen & Antworten
- **Welche Farbe ist das?** → Es ist **blau**.
- **Was ist deine Lieblingsfarbe?** → Meine Lieblingsfarbe ist **grün**.

## Übungstipp
Schau dich um und nenne 5 Dinge mit ihren Farben auf Deutsch! 🎨
""",
                },
                {
                    "title": "Häufige Formen",
                    "description": "Lerne die Namen der grundlegenden geometrischen Formen.",
                    "lesson_type": "vocabulary",
                    "content": """# Häufige Formen

## Grundformen

| Deutsch | Türkçe |
|---------|--------|
| der Kreis | daire |
| das Quadrat | kare |
| das Rechteck | dikdörtgen |
| das Dreieck | üçgen |
| der Stern | yıldız |
| das Herz | kalp |
| die Raute | baklava / eşkenar dörtgen |
| das Oval | oval |

## Formen beschreiben
- **Das ist ein Kreis.** → Bu bir dairedir.
- **Es ist quadratisch.** → Kare şeklinde.
- **Welche Form hat das?** → Şekli nedir?

## Farben + Formen zusammen
- ein **roter** Kreis → kırmızı bir daire
- ein **blaues** Quadrat → mavi bir kare
- ein **gelbes** Dreieck → sarı bir üçgen

## Beispielsätze
- Eine Pizza ist ein **Kreis**.
- Ein Buch ist ein **Rechteck**.
- Ein Verkehrsschild ist ein **Dreieck**.

## Übungstipp
Zeichne 5 Formen und schreibe ihre Namen und Farben auf Deutsch! ✏️
""",
                },
            ],
        },
        {
            "title": "Das Verb 'Sein'",
            "description": "Lerne das wichtigste Verb auf Deutsch: sein (to be).",
            "order": 4,
            "rules": "- ich bin / du bist / er/sie/es ist\n- wir sind / ihr seid / sie/Sie sind\n- Negation: nicht → ich bin nicht\n- Frage: Bist du...? Ist er...?",
            "examples": '["Ich bin Student.", "Sie ist glücklich.", "Wir sind aus der Türkei.", "Bist du müde?"]',
            "lessons": [
                {
                    "title": "Ich bin / Du bist / Er ist",
                    "description": "Lerne alle Formen des Verbs 'sein'.",
                    "lesson_type": "grammar",
                    "content": """# Ich bin / Du bist / Er ist

## Das Verb "sein" — Positive Form

| Person | Sein | Kurzform | Türkçe |
|--------|------|----------|--------|
| ich | bin | ich bin | Ben -im |
| du | bist | du bist | Sen -sin |
| er / sie / es | ist | er ist | O -dır |
| wir | sind | wir sind | Biz -iz |
| ihr | seid | ihr seid | Siz -siniz |
| sie / Sie | sind | sie sind | Onlar -dır |

## Beispielsätze
- **Ich bin** Student. (Ben öğrenciyim.)
- **Du bist** müde. (Sen yorgunsun.)
- **Er ist** Arzt. (O doktor.)
- **Wir sind** aus der Türkei. (Türkiye'denim.)
- **Sie sind** Lehrer. (Onlar öğretmen.)

## Häufige Verwendungen
1. **Berufe:** Ich **bin** Lehrer.
2. **Nationalität:** Er **ist** Türke.
3. **Eigenschaften:** Sie **ist** nett.
4. **Ort:** Wir **sind** in Berlin.
5. **Gefühle:** Ich **bin** glücklich.

## Übungstipp
Schreib 5 Sätze über dich und deine Familie mit "sein"! ✍️
""",
                },
                {
                    "title": "Verneinung & Fragen mit 'Sein'",
                    "description": "Lerne, negative Sätze und Fragen mit 'sein' zu bilden.",
                    "lesson_type": "grammar",
                    "content": """# Verneinung & Fragen mit "Sein"

## Verneinung (Olumsuz)

Füge **nicht** nach "sein" hinzu:

| Positiv | Negativ |
|---------|---------|
| Ich bin müde. | Ich bin **nicht** müde. |
| Er ist Lehrer. | Er ist **nicht** Lehrer. |
| Wir sind hier. | Wir sind **nicht** hier. |

## Fragenform (Soru)

Stelle das Verb **vor** das Subjekt:

| Aussagesatz | Fragesatz |
|-------------|-----------|
| Du bist Student. | **Bist** du Student? |
| Sie ist glücklich. | **Ist** sie glücklich? |
| Ihr seid bereit. | **Seid** ihr bereit? |

## Kurze Antworten
- **Bist du Student?** → Ja, ich **bin** es. / Nein, ich **bin** es nicht.
- **Ist er aus Frankreich?** → Ja, er **ist** es. / Nein, er **ist** es nicht.

## Übungsdialog
**A:** Bist du Lehrer?
**B:** Nein, ich bin nicht Lehrer. Ich bin Student.
**A:** Ist sie deine Freundin?
**B:** Ja, sie ist meine Klassenkameradin.

## Übungstipp
Stelle 3 Fragen und schreib 3 negative Sätze über dich auf Deutsch! ❓
""",
                },
            ],
        },
        {
            "title": "Alltag & Uhrzeit",
            "description": "Sprich über deinen Tagesablauf und die Uhrzeit.",
            "order": 5,
            "rules": "- 'Wie spät ist es?' um die Uhrzeit zu fragen\n- 'Es ist [Uhrzeit] Uhr' für genaue Stunden\n- 'um' + Uhrzeit: Ich stehe um 7 Uhr auf\n- Alltagsverben: aufstehen, essen, schlafen",
            "examples": '["Ich stehe um 7 Uhr auf.", "Es ist halb vier.", "Sie geht um 8 Uhr in die Schule."]',
            "lessons": [
                {
                    "title": "Wie spät ist es?",
                    "description": "Lerne, die Uhrzeit auf Deutsch zu sagen und zu fragen.",
                    "lesson_type": "vocabulary",
                    "content": """# Wie spät ist es?

## Fragen & Antworten zur Uhrzeit

**Frage:** Wie spät ist es? / Wie viel Uhr ist es?
**Antwort:** Es ist [Uhrzeit].

## Uhrzeitausdrücke

| Uhrzeit | Deutsch | Türkçe |
|---------|---------|--------|
| 3:00 | Es ist drei Uhr. | Saat üç. |
| 3:15 | Es ist Viertel nach drei. | Üçü çeyrek geçiyor. |
| 3:30 | Es ist halb vier. | Üç buçuk. |
| 3:45 | Es ist Viertel vor vier. | Dörde çeyrek var. |
| 8:00 | acht Uhr morgens | Sabah sekiz. |
| 12:00 | Mittag | Öğlen. |
| 18:00 | achtzehn Uhr | Akşam altı. |
| 0:00 | Mitternacht | Gece yarısı. |

## Zeitvokabular

| Deutsch | Türkçe |
|---------|--------|
| der Morgen | sabah |
| der Nachmittag | öğleden sonra |
| der Abend | akşam |
| die Nacht | gece |
| heute | bugün |
| morgen | yarın |
| gestern | dün |

## Übungstipp
Stelle 3 Wecker ein und schreibe die Uhrzeiten auf Deutsch! ⏰
""",
                },
                {
                    "title": "Mein Tagesablauf",
                    "description": "Beschreibe deinen Alltag mit wichtigen Verben.",
                    "lesson_type": "reading",
                    "content": """# Mein Tagesablauf

## Alltagsverben

| Deutsch | Türkçe |
|---------|--------|
| aufstehen | kalkmak |
| duschen | duş almak |
| sich anziehen | giyinmek |
| frühstücken | kahvaltı etmek |
| zur Schule gehen | okula gitmek |
| zu Mittag essen | öğle yemeği yemek |
| nach Hause kommen | eve gelmek |
| zu Abend essen | akşam yemeği yemek |
| fernsehen | TV izlemek |
| schlafen gehen | yatmak |
| schlafen | uyumak |

## Ein Beispiel-Tagesablauf

> Ich **stehe** um 7 Uhr **auf**. Ich **dusche** und **ziehe mich an**.
> Um halb acht **frühstücke** ich. Ich esse meistens Brot mit Käse.
> Um 8 Uhr **gehe** ich **zur Schule**.
> Um 12:30 Uhr **esse ich zu Mittag** mit meinen Freunden.
> Um 16 Uhr **komme ich nach Hause**.
> Am Abend **mache ich Hausaufgaben** und **sehe fern**.
> Um 22:30 Uhr **gehe ich schlafen**.

## Zeitkonnektoren

| Wort | Bedeutung |
|------|-----------|
| zuerst | ilk önce |
| dann | sonra |
| danach | ondan sonra |
| schließlich | son olarak |
| um [Uhrzeit] | saat [saat]'de |
| morgens | sabahleyin |

## Übungstipp
Schreib deinen Tagesablauf mit mindestens 6 Verben und Uhrzeitangaben! 📅
""",
                },
            ],
        },
        {
            "title": "Essen & Trinken",
            "description": "Benenne Lebensmittel und Getränke, und bestelle im Café.",
            "order": 6,
            "rules": "- 'Ich mag/liebe/hasse + Nomen' für Vorlieben\n- 'Ich hätte gerne...' für höfliches Bestellen\n- Zählbar: ein Apfel, zwei Bananen\n- Nicht zählbar: etwas Wasser, etwas Brot",
            "examples": '["Ich mag Kaffee.", "Ich hätte gerne ein Sandwich, bitte.", "Haben Sie Orangensaft?"]',
            "lessons": [
                {
                    "title": "Häufige Lebensmittel & Getränke",
                    "description": "Lerne die Namen alltäglicher Lebensmittel und Getränke.",
                    "lesson_type": "vocabulary",
                    "content": """# Häufige Lebensmittel & Getränke

## Essen

| Deutsch | Türkçe |
|---------|--------|
| das Brot | ekmek |
| der Reis | pirinç |
| die Nudeln (Pl.) | makarna |
| das Fleisch | et |
| das Hühnchen | tavuk |
| der Fisch | balık |
| das Ei | yumurta |
| der Käse | peynir |
| der Salat | salata |
| die Suppe | çorba |
| der Apfel | elma |
| die Banane | muz |
| die Orange | portakal |
| die Tomate | domates |
| die Kartoffel | patates |

## Getränke

| Deutsch | Türkçe |
|---------|--------|
| das Wasser | su |
| der Tee | çay |
| der Kaffee | kahve |
| die Milch | süt |
| der Saft | meyve suyu |
| die Limonade | gazoz |

## Vorlieben ausdrücken

- Ich **mag** Tee. ✓
- Ich **liebe** Schokolade! ❤️
- Ich **mag** keine Zwiebeln. ✗
- Ich **hasse** bitteres Essen. 😣

## Übungstipp
Schreib alles auf, was du heute gegessen hast, auf Deutsch! 🍽️
""",
                },
                {
                    "title": "Im Café",
                    "description": "Übe das Bestellen von Essen und Getränken im Café.",
                    "lesson_type": "dialogue",
                    "content": """# Im Café ☕

## Nützliche Phrasen

| Deutsch | Türkçe |
|---------|--------|
| Was darf es sein? | Ne alırsınız? |
| Ich hätte gerne... | ...istiyorum / ...alabilir miyim |
| Kann ich... haben? | ...alabilir miyim? |
| Was möchten Sie? | Ne istersiniz? |
| Wie viel kostet das? | Ne kadar? |
| Bitte sehr! | Buyurun. |
| Danke schön! | Teşekkürler! |
| Guten Appetit! | Afiyet olsun! |

## Dialog: Im Café bestellen

**Kellner:** Guten Morgen! Was darf es sein?
**Kunde:** Guten Morgen! Ich hätte gerne einen Kaffee, bitte.
**Kellner:** Natürlich. Klein, mittel oder groß?
**Kunde:** Mittel, bitte. Und kann ich auch ein Sandwich haben?
**Kellner:** Selbstverständlich! Welches möchten Sie? Wir haben Käse und Hähnchen.
**Kunde:** Käse, bitte.
**Kellner:** Also ein mittlerer Kaffee und ein Käsesandwich. Noch etwas?
**Kunde:** Nein, danke. Wie viel kostet das?
**Kellner:** Das macht sieben Euro.
**Kunde:** Bitte sehr.
**Kellner:** Danke! Hier bitte. Guten Appetit!
**Kunde:** Danke!

## Schlüsselgrammatik: "hätte gerne"
**Ich hätte gerne** = höfliche Art zu bestellen
- Ich **hätte gerne** einen Tee. (✓ höflich)
- Ich **will** einen Tee. (✓ aber weniger höflich)

## Übungstipp
Übe diesen Dialog mit einem Freund — stell dir vor, du bist im Café! ☕🥪
""",
                },
            ],
        },
    ],
}

# ──────────────────────────────────────────────────────────────
# TURKISH A1
# ──────────────────────────────────────────────────────────────
TURKISH_A1 = {
    "language": "turkish",
    "level": "A1",
    "display_name": "Başlangıç",
    "description": "Temel iletişim, günlük kelime hazinesi (500–800 kelime), basit cümleler.",
    "order_index": 1,
    "topics": [
        {
            "title": "Selamlaşma ve Tanışma",
            "description": "Türkçe'de nasıl selam verileceğini ve tanışılacağını öğren.",
            "order": 1,
            "rules": "- 'Merhaba' / 'Selam' gündelik selamlama için\n- 'Günaydın / İyi akşamlar' belirli vakitler için\n- 'Benim adım...' ya da 'Adım...' kendinizi tanıtmak için\n- 'Adın ne?' (samimi) / 'Adınız ne?' (resmi)",
            "examples": '["Merhaba! Benim adım Ali.", "Günaydın! Nasılsınız?", "Tanıştığıma memnun oldum!"]',
            "lessons": [
                {
                    "title": "Merhaba! Temel Selamlaşmalar",
                    "description": "Günün her saati için temel selamlama ifadelerini öğren.",
                    "lesson_type": "vocabulary",
                    "content": """# Merhaba! Temel Selamlaşmalar

## Temel Kelimeler

| Türkçe | English |
|--------|---------|
| Merhaba / Selam | Hello / Hi |
| Günaydın | Good morning |
| İyi günler | Good day |
| İyi akşamlar | Good evening |
| İyi geceler | Good night |
| Hoşça kal | Goodbye (to person staying) |
| Görüşürüz | See you |
| Nasılsın? | How are you? (informal) |
| Nasılsınız? | How are you? (formal) |
| İyiyim, teşekkürler | I'm fine, thank you |
| Teşekkür ederim | Thank you |
| Rica ederim | You're welcome |
| Lütfen | Please |

## Örnek Diyalog

**A:** Merhaba! Nasılsın?
**B:** Selam! İyiyim, teşekkürler. Sen nasılsın?
**A:** Ben de iyiyim, teşekkürler!

---
**A:** Günaydın!
**B:** Günaydın! İyi günler!

## Samimi ve Resmi Kullanım
- **Samimi (sen):** Selam! Nasıl**sın**?
- **Resmi (siz):** Merhaba! Nasıl**sınız**?

## Egzersiz İpucu
Her sabah Türkçe "Günaydın!" diyerek başla! 🌞
""",
                },
                {
                    "title": "Adın Ne?",
                    "description": "Türkçe'de kendini tanıtmayı ve isim sormayı öğren.",
                    "lesson_type": "grammar",
                    "content": """# Adın Ne?

## Tanışma İfadeleri

| Türkçe | English |
|--------|---------|
| Benim adım [İsim]. | My name is [Name]. |
| Adım [İsim]. | My name is [Name]. |
| Adın ne? | What's your name? (informal) |
| Adınız ne? | What's your name? (formal) |
| Nerelisin? | Where are you from? |
| İngiltere'denim. | I'm from England. |
| Nerede yaşıyorsun? | Where do you live? |
| İstanbul'da yaşıyorum. | I live in Istanbul. |
| Tanıştığıma memnun oldum! | Nice to meet you! |
| Ben de! | Me too! |

## Örnek Diyalog

**A:** Merhaba! Adım Ahmet. Adın ne?
**B:** Merhaba Ahmet! Benim adım Zeynep. Nerelisin?
**A:** İngiltere'denim. Sen nerelisin?
**B:** Ben Türkiye'denim. Tanıştığıma memnun oldum!
**A:** Ben de memnun oldum!

## Yaş Söyleme
- Kaç yaşındasın? → Ben **yirmi** yaşındayım. (20)
- Ben **on beş** yaşındayım. (15)

## Türkçe Ek Sistemi
Türkçe'de "-den/-dan" eklenince "kökenini" belirtir:
- Türkiye → Türkiye'**den**im
- Amerika → Amerika'**dan**ım

## Egzersiz İpucu
Türkçe'de üç cümle yaz: adın, nereye geldiğin, ne yaptığın! 📝
""",
                },
            ],
        },
        {
            "title": "Sayılar ve Saymak",
            "description": "Türkçe'de 1'den 100'e kadar sayıları öğren.",
            "order": 2,
            "rules": "- 1–10: temel sayılar\n- 11–19: 'on' + rakam (on bir, on iki...)\n- 20, 30, 40...: yirmi, otuz, kırk...\n- Bileşik: yirmi bir, otuz beş",
            "examples": '["İki kedim var.", "Yirmi üç yaşındayım.", "Sınıfta on beş öğrenci var."]',
            "lessons": [
                {
                    "title": "Sayılar 1–20",
                    "description": "Türkçe'de 1'den 20'ye kadar saymayı öğren.",
                    "lesson_type": "vocabulary",
                    "content": """# Sayılar 1–20

## Sayılar

| Rakam | Türkçe | English |
|-------|--------|---------|
| 1 | bir | one |
| 2 | iki | two |
| 3 | üç | three |
| 4 | dört | four |
| 5 | beş | five |
| 6 | altı | six |
| 7 | yedi | seven |
| 8 | sekiz | eight |
| 9 | dokuz | nine |
| 10 | on | ten |
| 11 | on bir | eleven |
| 12 | on iki | twelve |
| 13 | on üç | thirteen |
| 14 | on dört | fourteen |
| 15 | on beş | fifteen |
| 16 | on altı | sixteen |
| 17 | on yedi | seventeen |
| 18 | on sekiz | eighteen |
| 19 | on dokuz | nineteen |
| 20 | yirmi | twenty |

## Örnek Cümleler
- **Beş** kitabım var.
- O **on iki** yaşında.
- Sınıfta **on beş** öğrenci var.

## Egzersiz İpucu
Odandaki nesneleri Türkçe say! 🔢
""",
                },
                {
                    "title": "Sayılar 21–100",
                    "description": "Bileşik sayıları ve 100'e kadar saymayı öğren.",
                    "lesson_type": "vocabulary",
                    "content": """# Sayılar 21–100

## Onlar

| Rakam | Türkçe | English |
|-------|--------|---------|
| 20 | yirmi | twenty |
| 30 | otuz | thirty |
| 40 | kırk | forty |
| 50 | elli | fifty |
| 60 | altmış | sixty |
| 70 | yetmiş | seventy |
| 80 | seksen | eighty |
| 90 | doksan | ninety |
| 100 | yüz | one hundred |

## Bileşik Sayılar
Onlar + birler:
- 21 → **yirmi bir**
- 35 → **otuz beş**
- 47 → **kırk yedi**
- 99 → **doksan dokuz**

## Örnek Cümleler
- **Yirmi üç** yaşındayım.
- Kitap **kırk beş** lira.
- Sınava **yüz** gün kaldı.

## Egzersiz İpucu
Telefon numaranı, doğum yılını ve ev numaranı Türkçe söyle! 📞
""",
                },
            ],
        },
        {
            "title": "Renkler ve Şekiller",
            "description": "Renkleri ve şekilleri kullanarak etrafındaki dünyayı tanımla.",
            "order": 3,
            "rules": "- Sıfatlar isimden önce gelir: 'kırmızı bir araba'\n- Renk sorusu: 'Rengi ne?' ya da 'Hangi renk?'\n- Şekil sorusu: 'Şekli ne?'",
            "examples": '["Gökyüzü mavi.", "Kırmızı bir arabam var.", "Çantanın rengi ne?"]',
            "lessons": [
                {
                    "title": "Temel Renkler",
                    "description": "Türkçe'deki temel renkleri öğren.",
                    "lesson_type": "vocabulary",
                    "content": """# Temel Renkler

## Renkler

| Türkçe | English | Örnek |
|--------|---------|-------|
| kırmızı | red | kırmızı bir elma |
| mavi | blue | mavi gökyüzü |
| yeşil | green | yeşil çimen |
| sarı | yellow | sarı muz |
| turuncu | orange | turuncu bir meyve |
| mor | purple | mor çiçekler |
| pembe | pink | pembe elbise |
| beyaz | white | beyaz kar |
| siyah | black | siyah kedi |
| gri | grey | gri bulutlar |
| kahverengi | brown | kahverengi toprak |

## Renkleri Kullanma
Renk isimden **önce** gelir:
- **kırmızı** bir araba
- **mavi** okyanus
- **yeşil** bir ağaç

## Soru ve Cevaplar
- **Rengi ne?** → **Mavi.**
- **En sevdiğin renk ne?** → En sevdiğim renk **yeşil**.

## Örnek Cümleler
- Elma **kırmızı**.
- Bugün **mavi** gömlek giyiyorum.
- Gözleri **yeşil**.

## Egzersiz İpucu
Etrafına bak ve 5 şeyi Türkçe renkleriyle söyle! 🎨
""",
                },
                {
                    "title": "Yaygın Şekiller",
                    "description": "Temel geometrik şekillerin isimlerini Türkçe öğren.",
                    "lesson_type": "vocabulary",
                    "content": """# Yaygın Şekiller

## Şekiller

| Türkçe | English |
|--------|---------|
| daire | circle |
| kare | square |
| dikdörtgen | rectangle |
| üçgen | triangle |
| yıldız | star |
| kalp | heart |
| baklava / eşkenar dörtgen | diamond |
| oval | oval |

## Şekilleri Tanımlama
- **Bu bir daire.** → It's a circle.
- **Kare şeklinde.** → It's square.
- **Şekli ne?** → What shape is it?

## Renkler + Şekiller
- **kırmızı** bir daire
- **mavi** bir kare
- **sarı** bir üçgen

## Örnek Cümleler
- Pizza bir **daire**.
- Kitap bir **dikdörtgen**.
- Trafik işareti bir **üçgen**.

## Egzersiz İpucu
5 şekil çiz ve Türkçe renk ve isimlerini yaz! ✏️
""",
                },
            ],
        },
        {
            "title": "'Olmak' Fiili",
            "description": "Türkçe'nin en temel fiilini öğren: olmak.",
            "order": 4,
            "rules": "- Ben -im / -yim\n- Sen -sin / -sın\n- O -dır / -dir / -dur / -dür\n- Biz -iz / -yiz\n- Siz -siniz\n- Onlar -dır(lar)\n- Olumsuz: değilim, değilsin...",
            "examples": '["Ben öğrenciyim.", "O mutlu.", "Türkiye\'denim.", "Öğretmen misin?"]',
            "lessons": [
                {
                    "title": "Ben/Sen/O — Olmak Fiili",
                    "description": "'Olmak' fiilinin tüm şekillerini öğren.",
                    "lesson_type": "grammar",
                    "content": """# Ben/Sen/O — Olmak Fiili

## "Olmak" — Olumlu Çekim

Türkçe'de "olmak" fiili ek olarak kullanılır:

| Özne | Ek | Örnek |
|------|----|-------|
| Ben | -im / -yim | Ben öğrenci**yim**. |
| Sen | -sin / -sın | Sen mutlu**sun**. |
| O | -dır / -dir | O doktor**(dur)**. |
| Biz | -iz / -yiz | Biz Türkiye'de**yiz**. |
| Siz | -siniz | Siz öğretmen**siniz**. |
| Onlar | -dır(lar) | Onlar öğrenci**(ler)**. |

> 📌 Türkçe'de "to be" fiili ayrı bir kelime değil, ektir!

## Örnek Cümleler
- Ben **öğrenciyim**. (I am a student.)
- Sen **yorgunsun**. (You are tired.)
- O **doktor**. / O **doktordur**.
- Biz **Türkiye'deyiz**. (We are in Turkey.)
- Onlar **öğretmen**. (They are teachers.)

## Yaygın Kullanımlar
1. **Meslek:** Ben **doktorum**.
2. **Milliyet:** O **Türk**.
3. **Özellik:** Sen **zekisin**.
4. **Yer:** Biz **İstanbul'dayız**.
5. **Duygu:** Ben **mutluyum**.

## Egzersiz İpucu
Kendinden ve ailenden 5 cümle yaz! ✍️
""",
                },
                {
                    "title": "Olumsuz ve Soru Yapısı",
                    "description": "Türkçe'de olumsuz cümle ve soru kurmayı öğren.",
                    "lesson_type": "grammar",
                    "content": """# Olumsuz ve Soru Yapısı

## Olumsuz Çekim

**değil** + şahıs eki:

| Olumlu | Olumsuz |
|--------|---------|
| Ben öğrenciyim. | Ben öğrenci **değilim**. |
| O öğretmen. | O öğretmen **değil**. |
| Biz buradayız. | Biz burada **değiliz**. |

## Soru Yapısı

**mı / mi / mu / mü** sonek olarak eklenir:

| Cümle | Soru |
|-------|------|
| Sen öğrencisin. | Sen öğrenci **misin**? |
| O mutlu. | O mutlu **mu**? |
| Onlar burada. | Onlar burada **mı**? |

## Kısa Cevaplar
- **Öğrenci misin?** → Evet, öğrenci**yim**. / Hayır, değil**im**.
- **O Fransız mı?** → Evet, **Fransız**. / Hayır, **değil**.

## Örnek Diyalog
**A:** Öğretmen misin?
**B:** Hayır, öğretmen değilim. Öğrenciyim.
**A:** O senin arkadaşın mı?
**B:** Evet, sınıf arkadaşım.

## Egzersiz İpucu
3 soru ve 3 olumsuz cümle yaz! ❓
""",
                },
            ],
        },
        {
            "title": "Günlük Rutin ve Saat",
            "description": "Günlük programınızdan ve saatten bahsedin.",
            "order": 5,
            "rules": "- 'Saat kaç?' saati sormak için\n- 'Saat [rakam].' tam saatler için\n- '-de / -da' ile saat belirtme: Saat 7'de kalkıyorum\n- Günlük fiiller: kalkmak, yemek, gitmek, uyumak",
            "examples": '["Saat 7\'de kalkıyorum.", "Saat üç buçuk.", "O saat 8\'de okula gidiyor."]',
            "lessons": [
                {
                    "title": "Saat Kaç?",
                    "description": "Türkçe'de saati sormayı ve söylemeyi öğren.",
                    "lesson_type": "vocabulary",
                    "content": """# Saat Kaç?

## Saat Sorma ve Söyleme

**Soru:** Saat kaç? / Kaçta?
**Cevap:** Saat [rakam].

## Saat İfadeleri

| Saat | Türkçe | English |
|------|--------|---------|
| 3:00 | Saat üç. | It's three o'clock. |
| 3:15 | Üçü çeyrek geçiyor. | Quarter past three. |
| 3:30 | Saat üç buçuk. | Half past three. |
| 3:45 | Dörde çeyrek var. | Quarter to four. |
| 8:00 sabah | Sabah saat sekiz. | 8 AM. |
| 12:00 | Öğlen. | Noon. |
| 18:00 | Akşam saat altı. | 6 PM. |
| 0:00 | Gece yarısı. | Midnight. |

## Zaman Kelime Hazinesi

| Türkçe | English |
|--------|---------|
| sabah | morning |
| öğleden sonra | afternoon |
| akşam | evening |
| gece | night |
| bugün | today |
| yarın | tomorrow |
| dün | yesterday |

## Örnek Cümleler
- **Saat kaç?** → Saat **on**.
- Saat **on birde** yatıyorum.
- Ders sabah **dokuzda** başlıyor.

## Egzersiz İpucu
3 alarm kur ve saatlerini Türkçe yaz! ⏰
""",
                },
                {
                    "title": "Günlük Rutinim",
                    "description": "Yaygın fiilleri kullanarak her gün ne yaptığını anlat.",
                    "lesson_type": "reading",
                    "content": """# Günlük Rutinim

## Günlük Fiiller

| Türkçe | English |
|--------|---------|
| uyanmak / kalkmak | to wake up / get up |
| duş almak | to take a shower |
| giyinmek | to get dressed |
| kahvaltı etmek | to have breakfast |
| okula / işe gitmek | to go to school / work |
| öğle yemeği yemek | to have lunch |
| eve gelmek | to come home |
| akşam yemeği yemek | to have dinner |
| televizyon izlemek | to watch TV |
| yatmak | to go to bed |
| uyumak | to sleep |

## Örnek Günlük Rutin

> Saat **7'de** kalkıyorum. Duş alıyorum ve giyiniyorum.
> **7:30'da** kahvaltı ediyorum. Genellikle yumurta ve çay içiyorum.
> Saat **8'de** okula gidiyorum.
> **12:30'da** arkadaşlarımla öğle yeme��i yiyorum.
> Saat **16'da** eve geliyorum.
> Akşam ödev yapıyorum ve televizyon izliyorum.
> **22:30'da** yatıyorum.

## Zaman Bağlacı

| Kelime | English |
|--------|---------|
| önce | first / before |
| sonra | then / after |
| ondan sonra | after that |
| son olarak | finally |
| saat [X]'de | at [X] o'clock |
| sabahleyin | in the morning |

## Egzersiz İpucu
En az 6 fiil ve saat kullanarak kendi günlük rutinini yaz! 📅
""",
                },
            ],
        },
        {
            "title": "Yiyecek ve İçecekler",
            "description": "Yaygın yiyecek ve içecekleri tanıyın, kafede sipariş verin.",
            "order": 6,
            "rules": "- 'Seviyorum / Sevmiyorum + nesne' tercihler için\n- 'Bir [şey] alabilir miyim?' kibarca sipariş için\n- Sayılabilir: bir elma, iki muz\n- Sayılamaz: biraz su, biraz ekmek",
            "examples": '["Kahveyi seviyorum.", "Bir sandviç alabilir miyim?", "Portakal suyu var mı?"]',
            "lessons": [
                {
                    "title": "Yaygın Yiyecekler ve İçecekler",
                    "description": "Günlük yiyecek ve içeceklerin isimlerini öğren.",
                    "lesson_type": "vocabulary",
                    "content": """# Yaygın Yiyecekler ve İçecekler

## Yiyecekler

| Türkçe | English |
|--------|---------|
| ekmek | bread |
| pirinç | rice |
| makarna | pasta |
| et | meat |
| tavuk | chicken |
| balık | fish |
| yumurta | egg |
| peynir | cheese |
| salata | salad |
| çorba | soup |
| elma | apple |
| muz | banana |
| portakal | orange |
| domates | tomato |
| patates | potato |

## İçecekler

| Türkçe | English |
|--------|---------|
| su | water |
| çay | tea |
| kahve | coffee |
| süt | milk |
| meyve suyu | juice |
| gazoz / kola | soda |

## Tercih Belirtme

- Çayı **seviyorum**. ✓
- Çikolatayı **çok seviyorum**! ❤️
- Soğanı **sevmiyorum**. ✗
- Acı yemekten **nefret ediyorum**. 😣

## Örnek Cümleler
- Kahvaltıda ekmek ve yumurta **yiyorum**.
- Her sabah kahve **içiyor**.
- Pizza **sever misin**?

## Egzersiz İpucu
Bugün yediklerini Türkçe yaz! 🍽️
""",
                },
                {
                    "title": "Kafede",
                    "description": "Bir kafede yiyecek ve içecek sipariş etmeyi pratik yap.",
                    "lesson_type": "dialogue",
                    "content": """# Kafede ☕

## Faydalı İfadeler

| Türkçe | English |
|--------|---------|
| Buyurun, ne alırsınız? | What would you like? |
| Bir [şey] alabilir miyim? | Can I have a [thing]? |
| Lütfen bir [şey] istiyorum. | I'd like a [thing], please. |
| Ne istersiniz? | What would you like? |
| Ne kadar? / Kaç lira? | How much is it? |
| Buyurun. | Here you are. |
| Teşekkürler! | Thank you! |
| Afiyet olsun! | Enjoy your meal! |

## Diyalog: Kafede Sipariş

**Garson:** Günaydın! Buyurun, ne alırsınız?
**Müşteri:** Günaydın! Bir kahve alabilir miyim lütfen?
**Garson:** Tabii. Küçük, orta veya büyük?
**Müşteri:** Orta olsun, lütfen. Bir de sandviç alabilir miyim?
**Garson:** Elbette! Hangi sandviç? Peynirli veya tavuklu var.
**Müşteri:** Peynirli olsun, lütfen.
**Garson:** Bir orta boy kahve ve bir peynirli sandviç. Başka?
**Müşteri:** Hayır, teşekkürler. Ne kadar?
**Garson:** Yetmiş lira.
**Müşteri:** Buyurun.
**Garson:** Teşekkürler! Buyurun. Afiyet olsun!
**Müşteri:** Teşekkürler!

## Kibar Sipariş: "alabilir miyim"
**Bir [şey] alabilir miyim?** = kibar sipariş
- Bir çay **alabilir miyim**? (✓ kibar)
- Bir çay **istiyorum**. (✓ ama daha az kibar)

## Egzersiz İpucu
Bu diyaloğu bir arkadaşınla pratik yap — sanki kafedeymiş gibi yap! ☕🥪
""",
                },
            ],
        },
    ],
}

# ──────────────────────────────────────────────────────────────
# Seed işlemi
# ──────────────────────────────────────────────────────────────

ALL_CONTENT = [ENGLISH_A1, GERMAN_A1, TURKISH_A1]


def seed_language(db, data: dict):
    language = data["language"]
    level = data["level"]
    print(f"\n{'='*50}")
    print(f"  {language.upper()} {level}")
    print(f"{'='*50}")

    existing = db.query(LanguageLevel).filter_by(language=language, level=level).first()
    if existing:
        print(f"  LanguageLevel zaten var (id={existing.id}), üzerine yazılıyor.")
        lang_level = existing
        lang_level.display_name = data["display_name"]
        lang_level.description = data["description"]
        lang_level.order_index = data["order_index"]
    else:
        lang_level = LanguageLevel(
            language=language,
            level=level,
            display_name=data["display_name"],
            description=data["description"],
            order_index=data["order_index"],
            is_active=True,
            min_vocabulary=500,
            max_vocabulary=800,
        )
        db.add(lang_level)
    db.flush()
    print(f"  ✓ LanguageLevel (id={lang_level.id})")

    for topic_data in data["topics"]:
        existing_topic = db.query(GrammarTopic).filter_by(
            language_level_id=lang_level.id, title=topic_data["title"]
        ).first()

        if existing_topic:
            topic = existing_topic
        else:
            topic = GrammarTopic(
                language_level_id=lang_level.id,
                title=topic_data["title"],
                description=topic_data["description"],
                language=language,
                level=level,
                order_index=topic_data["order"],
                is_active=True,
                rules=topic_data.get("rules", ""),
                examples=topic_data.get("examples", "[]"),
            )
            db.add(topic)
        db.flush()
        print(f"  ✓ Konu: {topic_data['title']}")

        for i, lesson_data in enumerate(topic_data["lessons"], 1):
            existing_lesson = db.query(Lesson).filter_by(
                grammar_topic_id=topic.id, title=lesson_data["title"]
            ).first()
            if existing_lesson:
                print(f"    - Ders zaten var: {lesson_data['title']}")
                continue

            lesson = Lesson(
                grammar_topic_id=topic.id,
                title=lesson_data["title"],
                description=lesson_data["description"],
                content=lesson_data["content"],
                lesson_type=lesson_data.get("lesson_type", "vocabulary"),
                language=language,
                level=level,
                order_index=i,
                is_active=True,
            )
            db.add(lesson)
            print(f"    + Ders eklendi: {lesson_data['title']}")

    db.commit()
    print(f"  ✅ {language.upper()} {level} tamamlandı!")


def main():
    db = SessionLocal()
    try:
        for data in ALL_CONTENT:
            seed_language(db, data)

        print("\n\n🎉 Tüm içerik başarıyla oluşturuldu!")
        ll = db.query(LanguageLevel).count()
        gt = db.query(GrammarTopic).count()
        ls = db.query(Lesson).count()
        print(f"\nÖzet:")
        print(f"  LanguageLevel : {ll}")
        print(f"  GrammarTopic  : {gt}")
        print(f"  Lesson        : {ls}")
    finally:
        db.close()


if __name__ == "__main__":
    main()
