describe Fastlane do
  describe Fastlane::FastFile do
    describe "PEM Integration" do

      it "works with no parameters" do
        result = Fastlane::FastFile.new.parse("lane :test do 
          pem
        end").runner.execute(:test)
      end

      it "support a success callback block" do
        temp_path = "/tmp/fastlane_callback.txt"
        File.delete(temp_path) rescue nil

        expect(File.exists?(temp_path)).to eq(false)

        result = Fastlane::FastFile.new.parse("lane :test do 
          pem(
            new_profile: Proc.new do |value|
              File.write('#{temp_path}', '1')
            end
            )
        end").runner.execute(:test)
        
        expect(File.exists?(temp_path)).to eq(true)
      end

    end
  end
end