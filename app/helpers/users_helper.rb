module UsersHelper
  def gravatar_for user, size: Settings.user_setting.gravata_profile_size
    gravatar_id = Digest::MD5.hexdigest(user.email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
