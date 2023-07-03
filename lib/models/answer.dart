//Для кэширования ответов на устройстве
class Answer {
  //Номер вопроса на удалённом сервере
  final int id;
  //Текст вопроса
  final String question;
  //Индекс ответа
  final int answer;

  const Answer(
      {required this.id, required this.question, required this.answer});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer_number': answer,
    };
  }
}
