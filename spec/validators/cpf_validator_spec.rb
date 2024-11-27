require "rails_helper"
class CpfValidatable
    include ActiveModel::Validations
    attr_accessor :cpf
  
    validates :cpf, cpf: true
  end
  
  RSpec.describe CpfValidatable do
    it 'validates if cpf is valid' do
      subject.cpf = '239.569.330-87'
      expect(subject.valid?).to be(true)
    end
  
    it 'validates if cpf is invalid' do
      subject.cpf = '123.654.987-11'
      expect(subject.valid?).to be(false)
      expect(subject.errors['cpf']).to eq ['não é válido']
    end
  end
  