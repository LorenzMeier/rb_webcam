require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Webcam do
  share_examples_for "Webcam which closed" do
    it { lambda{ @c_webcam.grab }.should raise_error(RuntimeError, "Camera has'nt be initialized") }
  end

  share_examples_for "Webcam which lives a full life" do
    it { @c_webcam.should_not be_nil }
    it { @c_webcam.capture_handler.should be_instance_of(FFI::Pointer) }
    it { @c_webcam.grab.should be_instance_of(FFI::Pointer) }
    it { @c_webcam.size[:width].should > 0.0 }
    it { @c_webcam.close.should be_nil }
    it_should_behave_like "Webcam which closed"
  end

  context "when given camera_id: 0, size: 160x120" do
    before(:all) do
      @size = { width: 160.0, height: 120.0 }
      @c_webcam = Webcam.new(0, @size)
    end

    it "should have specified size" do
      @c_webcam.size.should == @size
    end

    it_should_behave_like "Webcam which lives a full life"
  end

  context "when grab a frame using method with block" do
    before do
      @c_webcam
      Webcam.open(0) do |camera|
        @c_webcam = camera
      end
    end

    it_should_behave_like "Webcam which closed"
  end
end
