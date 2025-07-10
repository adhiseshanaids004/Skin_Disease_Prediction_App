class ChatBotService {
  static String getReply(String userInput) {
    userInput = userInput.toLowerCase();

    if (userInput.contains("eczema")) {
      return "Eczema is a skin condition causing redness and itching. Use moisturizers and avoid triggers.";
    } else if (userInput.contains("acne")) {
      return "Acne is caused by blocked pores. Use salicylic acid or consult a dermatologist.";
    } else if (userInput.contains("psoriasis")) {
      return "Psoriasis is a chronic autoimmune condition. Phototherapy and medicated creams may help.";
    } else if (userInput.contains("thank")) {
      return "You're welcome! Stay healthy!";
    } else {
      return "I'm not sure, please consult a dermatologist.";
    }
  }
}
