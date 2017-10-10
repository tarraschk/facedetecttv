Rails.application.routes.draw do
  resources :videos do
    get 'extract_images', to: 'videos#extract_images'
    get 'images_zip', to: 'videos#images_zip'
  end

  root to: 'home#landing_page'
end
