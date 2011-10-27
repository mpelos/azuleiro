require 'spec_helper'

describe User do
  describe "#active?" do
    subject { user.active? }

    context "when the user is active" do
      let(:user) { Fabricate.build :active_user }
      it { should be_true }
    end

    context "when the user is not active" do
      let(:user) { Fabricate.build :inactive_user }
      it { should be_false }
    end
  end

  describe "#inactive?" do
    subject { user.inactive? }

    context "when the user is active" do
      let(:user) { Fabricate.build :active_user }
      it { should be_false }
    end

    context "when the user is not active" do
      let(:user) { Fabricate.build :inactive_user }
      it { should be_true }
    end
  end

  describe "#activate!" do
    context "when the user is inactive" do
      let!(:user) { Fabricate :inactive_user }

      it "actives the user" do
        expect { user.activate! }.to change { user.active? }.from(false).to(true)
      end

      it "sends the welcome email" do
        expect { user.activate! }.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end

    context "when the user is already activated" do
      let!(:user) { Fabricate :active_user }

      it "doesn't send the welcome email" do
        expect { user.activate! }.to_not change { ActionMailer::Base.deliveries.size }
      end
    end
  end
end
