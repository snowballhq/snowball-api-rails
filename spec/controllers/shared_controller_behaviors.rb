shared_examples 'a restricted api controller' do
  it 'requires an authentication token' do
    expect(controller).to receive :restrict_access!
    action.call
  end
end
