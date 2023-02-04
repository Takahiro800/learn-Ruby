require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, projct, message" do
    note = Note.new(
      user: user,
      project: project,
      message: "This is a simple note.",
    )

    expect(note).to be_valid
  end

  # メッセージがなければ無効なこと
  it "is invalid withiout a message." do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  # 検索文字列に一致するメッセージを検索する
  describe "search message for a term" do
    let!(:note1) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the first note."
      )
    }


    let!(:note2) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the second note."
      )
    }

    let!(:note3) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "First, preheat the oven."
      )
    }

    # 一致するデータが見つかるとき
    context "when a match is found." do
      # 検索文字列に一致する Note を返すこと
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(note1, note3)
      end
    end

    # 一致するデータが一件も見つからないとき
    context "when no match is found" do
      # 空のコレクションを返すこと
      it "return an empty collection" do
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end
end
