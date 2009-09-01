module BehaviorTestHelper

  class NoCacheBehavior < Behavior::Base
    register 'No Cache'
    description 'Turns caching off for testing.'
    
    def cache_page?
      false
    end
  end
  
  class TestBehavior < Behavior::Base
    register 'Test Behavior'
    description 'this is just a test behavior'
    
    define_tags do
      tag 'test1' do
        'Hello world!'
      end
    end
    
    define_tags do
      tag 'test2' do
        'Another test.'
      end
    end
    
    define_child_tags do
      tag 'test' do
        page.slug
      end
    end
    
    def page_headers
      {
        'cool' => 'beans',
        'request' => @request.inspect[20..30],
        'response' => @response.inspect[20..31]
      }
    end
    
    def cache_page?
      false
    end
  end

end