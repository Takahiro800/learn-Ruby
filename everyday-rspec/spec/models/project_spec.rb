require 'rails_helper'

RSpec.describe Project, type: :model do
  # たくさんのメモがついていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  # ユーザー単位では、　重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = FactoryBot.create(:user)

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

    user = FactoryBot.create(:user)
    user.projects.create(
      name: "Test Project",
    )

    other_user = FactoryBot.create(
      :user,
      email: 'janetester@example.com',
    )
    other_project = other_user.projects.build(
      name: "Test Project"
    )

    expect(other_project).to be_valid
  end

  # 遅延ステータス
  describe "late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)

      expect(project).to be_late
    end

    # 締切日が今日なら遅延していないこと
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)

      expect(project).to_not be_late
    end

    # 締切日が明日なら遅延していないこと
    it "is on time when the due date is tommorow" do
      project = FactoryBot.create(:project, :due_tomorrow)

      expect(project).to_not be_late
    end
  end
end