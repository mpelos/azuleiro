require 'spec_helper'

describe Flight do
  it { should validate_presence_of :origin }
  it { should validate_presence_of :destination }
  it { should validate_presence_of :date }

  describe ".from" do
    let(:wutai) { Fabricate :city, :name => "Wutai" }
    let(:junon) { Fabricate :city, :name => "Junon" }

    let!(:flight_from_wutai) { Fabricate :flight, :origin => wutai }
    let!(:flight_from_junon) { Fabricate :flight, :origin => junon }

    context "junon" do
      subject { described_class.from junon }
      it { should include flight_from_junon }
      it { should_not include flight_from_wutai }
    end

    context "wutai" do
      subject { described_class.from wutai }
      it { should_not include flight_from_junon }
      it { should include flight_from_wutai }
    end
  end

  describe ".to" do
    let(:wutai) { Fabricate :city, :name => "Wutai" }
    let(:junon) { Fabricate :city, :name => "Junon" }

    let!(:flight_to_wutai) { Fabricate :flight, :destination => wutai }
    let!(:flight_to_junon) { Fabricate :flight, :destination => junon }

    context "junon" do
      subject { described_class.to junon }
      it { should include flight_to_junon }
      it { should_not include flight_to_wutai }
    end

    context "wutai" do
      subject { described_class.to wutai }
      it { should_not include flight_to_junon }
      it { should include flight_to_wutai }
    end
  end
end
