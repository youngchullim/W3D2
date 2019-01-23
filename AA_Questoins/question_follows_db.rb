require 'sqlite3'
require 'singleton'
require_relative 'users_db'

class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class QuestionFollow
  attr_accessor :id, :author_id, :question_id
  def initialize(options)
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
  end
  
  def self.followers_for_question_id(question_id)
    following = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      users
    JOIN
      question_follows ON users.id = question_follows.author_id
    WHERE
      question_follows.question_id = ?
    SQL

    return nil unless following.length > 0
    following.map { |el| User.new(el) } 
  end
  
  def self.followed_question_for_user_id(user_id)
    following = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_follows ON questions.id = question_follows.question_id
    WHERE
      question_follows.question_id = ?
    SQL

    return nil unless following.length > 0
    following.map { |el| Question.new(el) }
  end

  def self.most_followed_question(n)
    following = QuestionsDBConnection.instance.execute(<<-SQL,n-1)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_follows ON questions.id = question_follows.question_id
    GROUP BY 
      question_id 
    ORDER BY
      COUNT(question_id) DESC
      LIMIT 1 OFFSET ? 
    SQL
    Question.new(following[0])
  end
   
end 