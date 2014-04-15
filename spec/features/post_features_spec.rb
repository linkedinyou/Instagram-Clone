require 'spec_helper' 


describe 'post index page' do 

  before(:each) do 
    login_as_test_user
  end 

  context 'no post' do 
    it 'shows a message' do 
      visit '/posts'
      expect(page).to have_content 'No posts yet'
    end
  end  

  describe 'adding posts' do
    context 'valid post' do
      it 'is added to the post page' do
        visit '/posts/new'
        fill_in 'Description', with: 'My holiday pic'
        attach_file 'Picture', Rails.root.join('spec/images/kitteh.jpg')
        click_button 'Create Post'
        expect(current_path).to eq('/posts')
        expect(page).to have_content('My holiday pic')
      end
    end

    context 'invalid post' do
      it 'shows an error' do
        visit '/posts/new'
        click_button 'Create Post'
        expect(page).to have_content('error')
      end
    end
  end

  context 'with posts' do

    it 'displays the post' do
      visit '/posts/new'
      fill_in 'Description', with: 'some awesome snap'
      attach_file 'Picture', Rails.root.join('spec/images/kitteh.jpg')
      click_button 'Create Post'
      visit '/posts'
      expect(page).to have_content('some awesome snap')
    end
  end

  context 'tags' do 

    before {Post.create(description: 'kitteh', picture: Rails.root.join('spec/images/kitteh.jpg').open, tag_name: '#meow')}
  
    it 'should display tags with post' do 
      visit '/posts'
      expect(page).to have_content('#meow')
    end  
  end  

  describe 'deleting posts' do

    it 'remove post from index page after deletion' do
      visit '/posts/new'
      fill_in 'Description', with: 'My holiday pic'
      attach_file 'Picture', Rails.root.join('spec/images/kitteh.jpg')
      click_button 'Create Post'      
      click_link 'Delete Post'
      expect(page).not_to have_content('kitteh')
    end
  end
end



