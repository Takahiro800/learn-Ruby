require 'rails_helper'

RSpec.describe Project, type: :model do
  # ユーザー単位では、　重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'test@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze',
    )

    user.projects.create(
      name: "Test project",
    )

    new_project = user.projects.build(
      name: "Test project",
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    user = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'test@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze',
    )
  end
end
