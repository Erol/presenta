require_relative '../helper.rb'

describe Presenta do
  before do
    instance_eval do
      class Person
        attr_accessor :firstname
        attr_accessor :middlename
        attr_accessor :lastname

        attr_accessor :email

        attr_accessor :birthdate
      end

      class Presenter
        include Presenta
      end
    end
  end

  let :person do
    person = Person.new

    person.firstname = 'Alice'
    person.middlename = 'In'
    person.lastname = 'Wonderland'

    person.email = 'alice@wonderland'

    person.birthdate = Date.today

    person
  end

  let :presenter do
    Presenter.new person
  end

  specify ".new assigns an entity" do
    assert_equal person, presenter.entity
  end

  specify ".subject defines a subject" do
    class << presenter
      subject :person
    end

    assert_equal person, presenter.person
  end

  specify ".present accepts a name" do
    class << presenter
      present :firstname
      present :middlename
      present :lastname
    end

    assert_equal person.firstname, presenter.firstname
    assert_equal person.middlename, presenter.middlename
    assert_equal person.lastname, presenter.lastname
  end
end
