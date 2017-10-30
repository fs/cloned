account1 = Account.create(name: 'First Company Account')
department_a = Department.create(account: account1, name: 'Dep A', employees_count: 1)
department_a.create_address(adds: 'London, Baker str. 233 B', zipcode: 'NW1/W1')

bob = Employee.create(department: department_a, firstname: 'Bob', lastname: 'Dylan')
bob.create_address(adds: 'USSR, Moscow Lyubyanka 33', zipcode: '3324')

{ Time.now => 2000, 1.month.ago => 500, 2.months.ago => 1001, 3.months.ago => 100 }.each do |date, total|
  bob.payrolls.create!(date: date, total: total)
end

department_b = Department.create(account: account1, name: 'Dep B', employees_count: 1)
jane = Employee.create(department: department_b, firstname: 'Jane', lastname: 'McAlister')
jane.create_address(adds: 'Miami, Mulholland Drive 90-39', zipcode: '34434')
{ Time.now => 999, 1.month.ago => 500, 2.months.ago => 3000, 3.months.ago => 2000 }.each do |date, total|
  jane.payrolls.create!(date: date, total: total)
end

account2 = Account.create(name: 'Second Company Account')
