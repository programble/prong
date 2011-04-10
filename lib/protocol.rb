module Prong
  module Protocol
    VERSION = 1
    module Commands
      CONNECT = *1..1
    end
    module Replies
      CONNECTION_ACCEPTED, CONNECTION_REJECTED = *1..2
    end
  end
end
