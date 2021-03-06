require 'rdf'
require 'rdf/spec'

share_as :RDF_URI do
  before :each do
    raise '+@new+ must be defined in a before(:each) block' unless instance_variable_get('@new')
  end

  it "should be instantiable" do
    lambda { @new.call('http://rdf.rubyforge.org/') }.should_not raise_error
  end

  it "should recognize URNs" do
    urns = %w(urn:isbn:0451450523 urn:isan:0000-0000-9E59-0000-O-0000-0000-2 urn:issn:0167-6423 urn:ietf:rfc:2648 urn:mpeg:mpeg7:schema:2001 urn:oid:2.16.840 urn:uuid:6e8bc430-9c3a-11d9-9669-0800200c9a66 urn:uci:I001+SBSi-B10000083052)
    urns.each do |urn|
      uri = @new.call(urn)
      uri.should be_a_uri
      uri.should respond_to(:urn?)
      uri.should be_a_urn
      uri.should_not be_a_url
    end
  end

  it "should recognize URLs" do
    urls = %w(mailto:jhacker@example.org http://example.org/ ftp://example.org/)
    urls.each do |url|
      uri = @new.call(url)
      uri.should be_a_uri
      uri.should respond_to(:url?)
      uri.should be_a_url
      uri.should_not be_a_urn
    end
  end

  it "should return the root URI" do
    uri = @new.call('http://rdf.rubyforge.org/RDF/URI.html')
    uri.should respond_to(:root)
    uri.root.should be_a_uri
    uri.root.should == @new.call('http://rdf.rubyforge.org/')
  end

  it "should find the parent URI" do
    uri = @new.call('http://rdf.rubyforge.org/RDF/URI.html')
    uri.should respond_to(:parent)
    uri.parent.should be_a_uri
    uri.parent.should == @new.call('http://rdf.rubyforge.org/RDF/')
    uri.parent.parent.should == @new.call('http://rdf.rubyforge.org/')
    uri.parent.parent.parent.should be_nil
  end

  it "should have a consistent hash code" do
    hash1 = @new.call('http://rdf.rubyforge.org/').hash
    hash2 = @new.call('http://rdf.rubyforge.org/').hash
    hash1.should == hash2
  end

  it "should be duplicable" do
    url  = Addressable::URI.parse('http://rdf.rubyforge.org/')
    uri2 = (uri1 = @new.call(url)).dup

    uri1.should_not be_equal(uri2)
    uri1.should be_eql(uri2)
    uri1.should == uri2

    url.path = '/rdf/'
    uri1.should_not be_equal(uri2)
    uri1.should_not be_eql(uri2)
    uri1.should_not == uri2
  end

  it "should not be #anonymous?" do
    @new.call('http://example.org').should_not be_anonymous
  end
end
