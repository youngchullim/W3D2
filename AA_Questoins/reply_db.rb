require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Reply
  attr_accessor :id, :question_id, :author_id, :parent_id, :body

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @author_id = options['author_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end

  def self.find_by_id(id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, id)

    SELECT
      *
    FROM 
      replies
    WHERE
      id = ?
  SQL
    return nil unless reply.length > 0
    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, user_id)

    SELECT
      *
    FROM 
      replies
    WHERE
      author_id = ?
    SQL
    return nil unless reply.length > 0
    Reply.new(reply.first)
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, question_id)

    SELECT
      *
    FROM 
      replies
    WHERE
      question_id = ? 
    SQL
    return nil unless reply.length > 0
    Reply.new(reply.first)
  end

  def author
    Users.find_by_id(@author_id)
  end

  def question
    Question.find_by_question_id(@question_id)
  end

  def parent_reply
    self.find_by_id(@parent_id)
  end

  def child_replies
    parent = @id
    child = QuestionsDBConnection.instance.execute(<<-SQL, parent)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
    SQL
  end
  

end