// Language data for LinguaLearn — CodeAlpha Task 4.
// 90 words/phrases total: 30 per language (12 Vocabulary + 10 Phrases + 8 Grammar).
// The 90 words and phrases in this app.

/// One word, phrase or grammar item to learn.
class WordItem {
  const WordItem({required this.english, required this.target, required this.category});
  final String english;
  final String target;
  final String category;
}

/// One supported language and its 30 items.
class LanguageData {
  const LanguageData({required this.code, required this.name, required this.flag, required this.ttsLocale, required this.items});
  final String code;
  final String name;
  final String flag;
  final String ttsLocale;
  final List<WordItem> items;
}

/// All languages, keyed by language code ('es', 'fr', 'de').
const Map<String, LanguageData> languages = {
  'es': LanguageData(
    code: 'es',
    name: "Spanish",
    flag: '🇪🇸',
    ttsLocale: 'es-ES',
    items: [
      WordItem(english: "Hello", target: "Hola", category: "Vocabulary"),
      WordItem(english: "Goodbye", target: "Adiós", category: "Vocabulary"),
      WordItem(english: "Please", target: "Por favor", category: "Vocabulary"),
      WordItem(english: "Thank you", target: "Gracias", category: "Vocabulary"),
      WordItem(english: "Yes", target: "Sí", category: "Vocabulary"),
      WordItem(english: "No", target: "No", category: "Vocabulary"),
      WordItem(english: "Water", target: "El agua", category: "Vocabulary"),
      WordItem(english: "Food", target: "La comida", category: "Vocabulary"),
      WordItem(english: "House", target: "La casa", category: "Vocabulary"),
      WordItem(english: "Friend", target: "El amigo", category: "Vocabulary"),
      WordItem(english: "Book", target: "El libro", category: "Vocabulary"),
      WordItem(english: "Dog", target: "El perro", category: "Vocabulary"),
      WordItem(english: "How are you?", target: "¿Cómo estás?", category: "Phrases"),
      WordItem(english: "My name is...", target: "Me llamo...", category: "Phrases"),
      WordItem(english: "Where is the bathroom?", target: "¿Dónde está el baño?", category: "Phrases"),
      WordItem(english: "I would like a coffee.", target: "Quisiera un café.", category: "Phrases"),
      WordItem(english: "How much does it cost?", target: "¿Cuánto cuesta?", category: "Phrases"),
      WordItem(english: "Good morning", target: "Buenos días", category: "Phrases"),
      WordItem(english: "Good night", target: "Buenas noches", category: "Phrases"),
      WordItem(english: "See you tomorrow", target: "Hasta mañana", category: "Phrases"),
      WordItem(english: "Excuse me", target: "Disculpe", category: "Phrases"),
      WordItem(english: "I don't understand", target: "No entiendo", category: "Phrases"),
      WordItem(english: "I am", target: "Yo soy", category: "Grammar"),
      WordItem(english: "You are", target: "Tú eres", category: "Grammar"),
      WordItem(english: "He is", target: "Él es", category: "Grammar"),
      WordItem(english: "We are", target: "Nosotros somos", category: "Grammar"),
      WordItem(english: "I have", target: "Yo tengo", category: "Grammar"),
      WordItem(english: "I like", target: "Me gusta", category: "Grammar"),
      WordItem(english: "The cat is black", target: "El gato es negro", category: "Grammar"),
      WordItem(english: "I am learning Spanish", target: "Estoy aprendiendo español", category: "Grammar"),
    ],
  ),
  'fr': LanguageData(
    code: 'fr',
    name: "French",
    flag: '🇫🇷',
    ttsLocale: 'fr-FR',
    items: [
      WordItem(english: "Hello", target: "Bonjour", category: "Vocabulary"),
      WordItem(english: "Goodbye", target: "Au revoir", category: "Vocabulary"),
      WordItem(english: "Please", target: "S'il vous plaît", category: "Vocabulary"),
      WordItem(english: "Thank you", target: "Merci", category: "Vocabulary"),
      WordItem(english: "Yes", target: "Oui", category: "Vocabulary"),
      WordItem(english: "No", target: "Non", category: "Vocabulary"),
      WordItem(english: "Water", target: "L'eau", category: "Vocabulary"),
      WordItem(english: "Food", target: "La nourriture", category: "Vocabulary"),
      WordItem(english: "House", target: "La maison", category: "Vocabulary"),
      WordItem(english: "Friend", target: "L'ami", category: "Vocabulary"),
      WordItem(english: "Book", target: "Le livre", category: "Vocabulary"),
      WordItem(english: "Dog", target: "Le chien", category: "Vocabulary"),
      WordItem(english: "How are you?", target: "Comment allez-vous ?", category: "Phrases"),
      WordItem(english: "My name is...", target: "Je m'appelle...", category: "Phrases"),
      WordItem(english: "Where is the bathroom?", target: "Où sont les toilettes ?", category: "Phrases"),
      WordItem(english: "I would like a coffee.", target: "Je voudrais un café.", category: "Phrases"),
      WordItem(english: "How much does it cost?", target: "Combien ça coûte ?", category: "Phrases"),
      WordItem(english: "Good morning", target: "Bonjour", category: "Phrases"),
      WordItem(english: "Good night", target: "Bonne nuit", category: "Phrases"),
      WordItem(english: "See you tomorrow", target: "À demain", category: "Phrases"),
      WordItem(english: "Excuse me", target: "Excusez-moi", category: "Phrases"),
      WordItem(english: "I don't understand", target: "Je ne comprends pas", category: "Phrases"),
      WordItem(english: "I am", target: "Je suis", category: "Grammar"),
      WordItem(english: "You are", target: "Tu es", category: "Grammar"),
      WordItem(english: "He is", target: "Il est", category: "Grammar"),
      WordItem(english: "We are", target: "Nous sommes", category: "Grammar"),
      WordItem(english: "I have", target: "J'ai", category: "Grammar"),
      WordItem(english: "I like", target: "J'aime", category: "Grammar"),
      WordItem(english: "The cat is black", target: "Le chat est noir", category: "Grammar"),
      WordItem(english: "I am learning French", target: "J'apprends le français", category: "Grammar"),
    ],
  ),
  'de': LanguageData(
    code: 'de',
    name: "German",
    flag: '🇩🇪',
    ttsLocale: 'de-DE',
    items: [
      WordItem(english: "Hello", target: "Hallo", category: "Vocabulary"),
      WordItem(english: "Goodbye", target: "Auf Wiedersehen", category: "Vocabulary"),
      WordItem(english: "Please", target: "Bitte", category: "Vocabulary"),
      WordItem(english: "Thank you", target: "Danke", category: "Vocabulary"),
      WordItem(english: "Yes", target: "Ja", category: "Vocabulary"),
      WordItem(english: "No", target: "Nein", category: "Vocabulary"),
      WordItem(english: "Water", target: "Das Wasser", category: "Vocabulary"),
      WordItem(english: "Food", target: "Das Essen", category: "Vocabulary"),
      WordItem(english: "House", target: "Das Haus", category: "Vocabulary"),
      WordItem(english: "Friend", target: "Der Freund", category: "Vocabulary"),
      WordItem(english: "Book", target: "Das Buch", category: "Vocabulary"),
      WordItem(english: "Dog", target: "Der Hund", category: "Vocabulary"),
      WordItem(english: "How are you?", target: "Wie geht es dir?", category: "Phrases"),
      WordItem(english: "My name is...", target: "Ich heiße...", category: "Phrases"),
      WordItem(english: "Where is the bathroom?", target: "Wo ist die Toilette?", category: "Phrases"),
      WordItem(english: "I would like a coffee.", target: "Ich hätte gern einen Kaffee.", category: "Phrases"),
      WordItem(english: "How much does it cost?", target: "Wie viel kostet das?", category: "Phrases"),
      WordItem(english: "Good morning", target: "Guten Morgen", category: "Phrases"),
      WordItem(english: "Good night", target: "Gute Nacht", category: "Phrases"),
      WordItem(english: "See you tomorrow", target: "Bis morgen", category: "Phrases"),
      WordItem(english: "Excuse me", target: "Entschuldigung", category: "Phrases"),
      WordItem(english: "I don't understand", target: "Ich verstehe nicht", category: "Phrases"),
      WordItem(english: "I am", target: "Ich bin", category: "Grammar"),
      WordItem(english: "You are", target: "Du bist", category: "Grammar"),
      WordItem(english: "He is", target: "Er ist", category: "Grammar"),
      WordItem(english: "We are", target: "Wir sind", category: "Grammar"),
      WordItem(english: "I have", target: "Ich habe", category: "Grammar"),
      WordItem(english: "I like", target: "Ich mag", category: "Grammar"),
      WordItem(english: "The cat is black", target: "Die Katze ist schwarz", category: "Grammar"),
      WordItem(english: "I am learning German", target: "Ich lerne Deutsch", category: "Grammar"),
    ],
  ),
};

const List<String> categories = ['All', 'Vocabulary', 'Phrases', 'Grammar'];
