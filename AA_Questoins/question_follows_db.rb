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
      *
    FROM
      users
    JOIN
      users ON users.id = question_follows.author_id
    WHERE
      id = ?
    SQL

    return nil unless following.length > 0
  end
  
  # def self.followed_question_for_user_id(user_id)
  #   following = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
  #   SELECT
  #     *
  #   FROM
  #   questions
  #   WHERE
  #   user_id = ?
  #   SQL

  #   return nil unless following.length > 0
  # end

  
end 