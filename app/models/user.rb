class User < ApplicationRecord
  has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:twitter]
  def self.from_omniauth(auth)
      where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
          user.provider = auth["provider"]
          user.uid = auth["uid"]
          user.username = auth["info"]["nickname"]
          user.image_url = auth["info"]["image"]
      end
  end
  def self.new_with_session(params, session)
      if session["devise.user_attributes"]
          new(session["devise.user_attributes"]) do |user|
            
              user.attributes = params
              user.valid?
          end
      else
          super
      end
  end

  def self.getPopularUsers
    Review.select(
        [
          Arel.star.count, User.arel_table[:username], User.arel_table[:image_url]
        ]
      ).joins(
        Review.arel_table.join(User.arel_table).on(
          Review.arel_table[:user_id].eq(User.arel_table[:id])
        ).join_sources
      ).order(Arel.star.count).reverse_order.group(:user_id).limit(10)
  end

  def password_required?
    super && provider.blank?
  end
  def email_required?
    super && provider.blank?
  end
end
