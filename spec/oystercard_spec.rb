require "oystercard"

describe Oystercard do

subject(:travelcard) {described_class.new}
subject(:empty_travelcard) {described_class.new}

let(:station) {double :station }

before(:each) do
  travelcard.top_up(20)
end

it "should respond to balance" do
  expect(travelcard).to respond_to(:balance)
end

it "should expect the balance to equal zero for a new card" do
  expect(empty_travelcard.balance).to eq(0)
end

it "should respond to 'top_up'" do
  expect(travelcard).to respond_to(:top_up)
end

it "should expect the balance to increase when card is topped up" do
  expect(travelcard.balance).to eq 20
end

it "should respond to 'in_journey'" do
  expect(travelcard).to respond_to(:in_journey?)
end

it "should tell us if we are not in journey" do
  travelcard.touch_out
  expect(travelcard.in_journey?).to be_falsey
end

 it "should initialize with a in_journey value of false" do
   expect(travelcard.in_journey?).to be_falsey
 end

 it "should set in_journey to true when we touch in" do
   travelcard.touch_in(station)
   expect(travelcard.in_journey?).to be_truthy
 end

 it "should reduce balance by 5 when you touch out" do
   expect { travelcard.touch_out }.to change{travelcard.balance}.by(-5)
 end

 it "should remember the station you touch in at" do
   travelcard.touch_in(station)
   expect(travelcard.entry_station).to eq station
 end

describe "error handling" do

  it "should raise an error when a top up takes the balance over 90" do
    message = "Top up too much. Maximum balance is £90."
    expect { travelcard.top_up(Oystercard::MAXIMUM_BALANCE) }.to raise_error(RuntimeError, message)
  end

  it "should raise an error when trying to touch in with not enough balance" do
    message = "Pauper"
    expect { empty_travelcard.touch_in(station) }.to raise_error(RuntimeError, message)
  end

end

end
