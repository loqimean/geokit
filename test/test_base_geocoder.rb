require File.join(File.dirname(__FILE__), "helper")

# Base class for testing geocoders.
class BaseGeocoderTest < Test::Unit::TestCase #:nodoc: all
  class Geokit::Geocoders::TestGeocoder < Geokit::Geocoders::Geocoder
    def self.do_get(url)
      sleep(2)
    end
  end

  # Defines common test fixtures.
  def setup
    @address = "San Francisco, CA"
    @full_address = "100 Spear St, San Francisco, CA, 94105-1522, US"
    @full_address_short_zip = "100 Spear St, San Francisco, CA, 94105, US"

    @latlng = Geokit::LatLng.new(37.7742, -122.417068)
    @success = Geokit::GeoLoc.new({city: "SAN FRANCISCO", state: "CA", country_code: "US", lat: @latlng.lat, lng: @latlng.lng})
    @success.success = true

    @keys = YAML.load(File.read('fixtures/keys.yml'))
  end

  def test_timeout_call_web_service
    url = "http://www.anything.com"
    Geokit::Geocoders.request_timeout = 1
    assert_nil Geokit::Geocoders::TestGeocoder.call_geocoder_service(url)
  end

  def test_successful_call_web_service
    url = "http://www.anything.com"
    Geokit::Geocoders::Geocoder.expects(:do_get).with(url).returns("SUCCESS")
    assert_equal "SUCCESS", Geokit::Geocoders::Geocoder.call_geocoder_service(url)
  end

  private

  def geocoder_class
    @geocoder_class ||= Geokit::Geocoders.const_get(self.class.name.gsub('Test', ''))
  end

  def escape(string)
    Geokit::Inflector.url_escape(string)
  end
end
