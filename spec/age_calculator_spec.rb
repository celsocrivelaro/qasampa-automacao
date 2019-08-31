describe "AgeCalculator" do
  it "calculates age" do
    expect(AgeCalculator.calculate("1980-01-01")).to eq 39
  end
end