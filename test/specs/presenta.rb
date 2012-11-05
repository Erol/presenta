require_relative '../helper.rb'

describe Presenta do
  before do
    instance_eval do
      class Person
        attr_accessor :firstname
        attr_accessor :middlename
        attr_accessor :lastname
        attr_accessor :nicknames

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
    person.nicknames = ['Alice', 'Wonder']

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

  describe ".present" do
    it "accepts a name" do
      class << presenter
        present :firstname
        present :middlename
        present :lastname
      end

      assert_equal person.firstname, presenter.firstname
      assert_equal person.middlename, presenter.middlename
      assert_equal person.lastname, presenter.lastname
    end

    it "accepts a name and type/presenter" do
      class EmailPresenter
        include Presenta
      end

      class << presenter
        present :email, EmailPresenter
      end

      assert_instance_of EmailPresenter, presenter.email
      assert_equal person.email, presenter.email.entity
    end

    it "accepts a name, type/presenter and attribute" do
      class DatePresenter
        include Presenta
      end

      class << presenter
        present :birthday, DatePresenter, :birthdate
      end

      assert_instance_of DatePresenter, presenter.birthday
      assert_equal person.birthdate, presenter.birthday.entity
      refute_respond_to presenter, :birthdate
    end

    it "accepts a name and block" do
      class << presenter
        present :fullname do
          [entity.firstname, entity.middlename, entity.lastname]
        end
      end

      assert_equal [person.firstname, person.middlename, person.lastname], presenter.fullname
    end

    it "accepts a name, type/presenter and block" do
      class NamePresenter
        include Presenta
      end

      class << presenter
        present :fullname, NamePresenter do
          [entity.firstname, entity.middlename, entity.lastname]
        end
      end

      assert_instance_of NamePresenter, presenter.fullname
      assert_equal [person.firstname, person.middlename, person.lastname], presenter.fullname.entity
    end

    it "raises an exception if both attribute and block was passed" do
      assert_raises ArgumentError do
        class << presenter
          present :birthday, Value, :birthdate do
            entity.birthdate
          end
        end
      end
    end

    describe "type" do
      it "can be a symbol" do
        class EmailPresenter
          include Presenta
        end

        class << presenter
          present :email, :EmailPresenter
        end

        assert_instance_of EmailPresenter, presenter.email
        assert_equal person.email, presenter.email.entity
      end

      it "can be an array of classes" do
        class NamePresenter
          include Presenta
        end

        class << presenter
          present :nicknames, Array[NamePresenter]
        end

        assert_instance_of Array, presenter.nicknames
        presenter.nicknames.each do |nickname|
          assert_instance_of NamePresenter, nickname
          assert_includes person.nicknames, nickname.entity
        end
      end
    end
  end
end
