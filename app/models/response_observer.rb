class ResponseObserver

  def self.notify(response_id)
    ResponseQueue.enqueue response_id
  end
end