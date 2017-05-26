describe ResponsesTracking do
  describe 'validations ' do
    it {should validate_presence_of(:user_id)}
    it {should validate_presence_of(:passage_id)}
    it {should validate_presence_of(:start_time)}

  end

  describe 'associations' do
    it {should belong_to(:user)}
    it {should belong_to(:passage)}

  end


  let(:passages) {
    [
        {
            title: 'Climate Change', text: 'climate change passage', start_time: DateTime.now, close_time: (DateTime.now+2), duration: '86400'
        },

        {
            title: 'Person', text: 'person passage', start_time: DateTime.now, close_time: (DateTime.now+1), duration: '2'
        }
    ]
  }

  let(:users) {

    [
        {
            name: 'Kamal Hasan', admin: false, auth_id: '132271', image_url: 'http://graph.facebook.com/demo1'
        },
        {
            name: 'Vimal Hasan', admin: false, auth_id: '132273', image_url: 'http://graph.facebook.com/demo1'
        },
        {
            name: 'Rajanikanth', admin: false, auth_id: '132272', image_url: 'http://graph.facebook.com/demo2'
        }
    ]
  }


  before(:each) do
    @users = User.create(users)
    @passages = Passage.create(passages)
  end

  after(:each) do
    ResponsesTracking.delete_all
    @users.each(&:delete)
    @passages.each(&:delete)
  end


  describe 'remaining_time' do
    context 'when the candidate has not taken the passage yet' do
      it 'should save the start time of the ongoing response session for the passage' do

        remaining_time = ResponsesTracking.remaining_time(@passages.first.id, @users.first.id)

        expect(remaining_time.round).to be(86400)

      end
    end
    context 'when the candidate has started the test and not yet completed' do
      it 'should give remaining time from the time the test started' do

        ResponsesTracking.create({passage_id: @passages.first.id, user_id: @users.first.id, start_time: (DateTime.now - 0.5)})
        expected_remaining_time = ResponsesTracking.remaining_time(@passages.first.id, @users.first.id)

        expect(expected_remaining_time.round).to be(43200)

      end
      it 'should give remaining time 0 if the duration has ended' do

        ResponsesTracking.create({passage_id: @passages.first.id, user_id: @users.first.id, start_time: (DateTime.now - 1)})
        expected_remaining_time = ResponsesTracking.remaining_time(@passages.first.id, @users.first.id)

        expect(expected_remaining_time.round).to be(0)

      end
      it 'should give remaining time 0 if the passage closing time is less than current date time' do

        ResponsesTracking.create({passage_id: @passages.first.id, user_id: @users.first.id, start_time: (DateTime.now + 1.98)})
        expected_remaining_time = ResponsesTracking.remaining_time(@passages.first.id, @users.first.id)

        expect(expected_remaining_time.round).to be(172800)

      end
    end
  end

end