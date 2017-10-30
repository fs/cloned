require 'spec_helper'
require 'seeds'

RSpec.describe Cloned::Strategy do
  class DepartmentStrategy < Cloned::Strategy
    declare :department do
      association :account
      association :address

      nullify :employees_count
    end

    declare :employee do
      association :address
    end
  end

  class EmployeeStrategy < Cloned::Strategy
    declare :employee do
      association :address
      association :payrolls, if: ->(payroll) { payroll.total > 1000 }
    end
  end

  let(:account1) { Account.first }
  let(:department_a) { Department.find_by(name: 'Dep A') }
  let(:department_b) { Department.find_by(name: 'Dep B') }
  let(:bob) { Employee.find_by(firstname: 'Bob') }
  let(:account2) { Account.second }

  describe '#make' do
    context 'with destination' do
      let(:target) { bob }
      let(:copy) { EmployeeStrategy.make(target: target, destination: department_b.employees) }

      it 'builds new record in destination' do
        expect(copy).to be_persisted
        expect(department_b.employees).to include(copy)
        expect(department_b.employees.first.payrolls.map(&:total)).to all(be > 1000)
      end
    end

    context 'without destination' do
      let(:target) { department_a }
      let(:copy) { DepartmentStrategy.make(target: target) }

      it 'builds new record with all associations' do
        expect(copy).to be_new_record
        expect(copy.employees_count).to be_nil
        expect(copy.account).to be_new_record
        expect(copy.account.name).to eq(account1.name)
      end

      context 'with has_many association' do
        let(:target) { bob }

        it 'builds new record with all associations' do
          expect(copy).to be_new_record
          expect(copy.payrolls.size).to be(0)
          expect(copy.address).to be_new_record
          expect(copy.address.adds).to eq(bob.address.adds)
        end
      end
    end
  end
end
