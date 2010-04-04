require 'rdf'
require 'rdf/spec'

share_as :RDF_Literal do

  XSD = RDF::XSD

  before :each do
    raise '+@new+ must be defined in a before(:each) block' unless instance_variable_get('@new')
  end

  context "plain literals" do
    before :each do
      @empty = @new.call('')
      @hello = @new.call('Hello')
      @all   = [@empty, @hello]
    end

    it "should be instantiable" do
      lambda { @new.call('') }.should_not raise_error
      @all.each do |literal|
        literal.plain?.should be_true
      end
    end

    it "should not have a language" do
      @all.each do |literal|
        literal.language.should be_nil
      end
    end

    it "should not have a datatype" do
      @all.each do |literal|
        literal.typed?.should be_false
        literal.datatype.should be_nil
      end
    end

    it "should support equality comparisons" do
      @all.each do |literal|
        copy = @new.call(literal.value)
        literal.should eql(copy)
        literal.should == copy

        literal.should_not eql(literal.value)
        literal.should == literal.value # FIXME
      end
    end

    it "should have a string representation" do
      @empty.to_s.should eql('""')
      @hello.to_s.should eql('"Hello"')
    end
  end

  context "languaged-tagged literals" do
    before :each do
      @empty = @new.call('', :language => :en)
      @hello = @new.call('Hello', :language => :en)
      @all   = [@empty, @hello]
    end

    it "should be instantiable" do
      lambda { @new.call('', :language => :en) }.should_not raise_error
    end

    it "should have a language" do
      @all.each do |literal|
        literal.language.should_not be_nil
        literal.language.should == :en
      end
    end

    it "should not have a datatype" do
      @all.each do |literal|
        literal.typed?.should be_false
        literal.datatype.should be_nil
      end
    end

    it "should support equality comparisons" do
      @all.each do |literal|
        copy = @new.call(literal.value, :language => literal.language)
        literal.should eql(copy)
        literal.should == copy
      end
    end

    it "should have a string representation" do
      @empty.to_s.should eql('""@en')
      @hello.to_s.should eql('"Hello"@en')
    end
  end

  context "datatyped literals" do
    require 'date'

    before :each do
      @string   = @new.call('')
      @false    = @new.call(false)
      @true     = @new.call(true)
      @int      = @new.call(123)
      @long     = @new.call(9223372036854775807)
      @double   = @new.call(3.1415)
      @time     = @new.call(Time.now)
      @date     = @new.call(Date.new(2010))
      @datetime = @new.call(DateTime.new(2010))
      @all      = [@false, @true, @int, @long, @double, @time, @date, @datetime]
    end

    it "should be instantiable" do
      lambda { @new.call(123) }.should_not raise_error
      lambda { @new.call(123, :datatype => XSD.int) }.should_not raise_error
    end

    it "should not have a language" do
      @all.each do |literal|
        literal.language.should be_nil
      end
    end

    it "should have a datatype" do
      @all.each do |literal|
        literal.typed?.should be_true
        literal.datatype.should_not be_nil
      end
    end

    it "should support implicit datatyping" do
      @string.datatype.should == nil
      @false.datatype.should == XSD.boolean
      @true.datatype.should == XSD.boolean
      @int.datatype.should == XSD.integer
      @long.datatype.should == XSD.integer
      @double.datatype.should == XSD.double
      @time.datatype.should == XSD.dateTime
      @date.datatype.should == XSD.date
      @datetime.datatype.should == XSD.dateTime
    end

    it "should support equality comparisons" do
      @all.each do |literal|
        copy = @new.call(literal.value, :datatype => literal.datatype)
        literal.should eql(copy)
        literal.should == copy
      end
    end

    it "should have a string representation" do
      @false.to_s.should eql('"false"^^<http://www.w3.org/2001/XMLSchema#boolean>')
      @true.to_s.should eql('"true"^^<http://www.w3.org/2001/XMLSchema#boolean>')
      @int.to_s.should eql('"123"^^<http://www.w3.org/2001/XMLSchema#integer>')
      @long.to_s.should eql('"9223372036854775807"^^<http://www.w3.org/2001/XMLSchema#integer>')
      @double.to_s.should eql('"3.1415"^^<http://www.w3.org/2001/XMLSchema#double>')
      @date.to_s.should eql('"2010-01-01"^^<http://www.w3.org/2001/XMLSchema#date>')
      @datetime.to_s.should eql('"2010-01-01T00:00:00+00:00"^^<http://www.w3.org/2001/XMLSchema#dateTime>') # FIXME
    end
  end

end
