class Post < ActiveRecord::Base
  include PgSearch

  before_validation :generate_slug

  is_impressionable counter_cache: true,
                    column_name: :views_count,
                    unique: :session_hash

  belongs_to :user, counter_cache: true

  has_many :items, -> { order('number ASC') }
  has_many :comments, as: :commentable

  has_many :like_relationships, dependent: :destroy
  has_many :likers, source: :user, through: :like_relationships

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :similar_posts, -> { uniq }, source: :posts, through: :tags

  accepts_nested_attributes_for :items, allow_destroy: true

  validates :title, presence: true

  validates :slug, uniqueness: true, presence: true

  # scope :page_with_counter_cache, lambda {|page_number, total_count_value|
  #   page(page_number).extending {
  #     # open scope to smuggle total_count
  #     define_method(:total_count) { total_count_value }
  #   }
  # }

  scope :newest, -> { order('posts.created_at DESC') }
  scope :hottest, -> { order('like_relationships_count DESC') }
  scope :most_viewed, -> { order('views_count DESC') }
  scope :exhibit, -> { hottest.limit(3) }

  pg_search_scope :search,
                  against: :title,
                  associated_against: {
                    items: [:name, :item_category_name],
                    user: [:full_name],
                    tags: [:name]
                  },
                  using: {
                    tsearch: {
                      prefix: true,
                      dictionary: 'english'
                    }
                  }

  def self.recent(time)
    where('posts.created_at > ?', Time.now - time)
  end

  def self.sort(sort)
    case sort
    when 'New'
      newest
    when 'Hot today'
      recent(1.day).hottest
    when 'Hot this week', nil
      recent(1.day).hottest
    when 'Hot this month'
      recent(1.week).hottest
    when 'Hot'
      hottest
    when 'Most Viewed'
      most_viewed
    end
  end

  def self.following(user)
    where(user_id: user.followed_users)
  end

  def self.from_my_channels(user)
    where(user_id: user.users_from_channels)
  end

  def self.from_channel(channel)
    where(user_id: channel.users)
  end

  def self.scope(scope_name, user)
    case scope_name
    when 'Everything'
      all
    when 'Following'
      following(user)
    else
      channel = Channel.find_by_name(scope_name)
      from_channel(channel)
    end
  end

  def self.exclude(posts)
    where.not(id: posts)
  end

  def self.exclude_user(users)
    where.not(user_id: users)
  end

  def likes
    like_relationships_count
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.upcase.split(",").reject{|s| s.blank?}.collect(&:strip).uniq.map do |n|
      Tag.where(name: n).first_or_create!
    end
  end

  def to_param
    slug
  end

  self

  def generate_slug
    if slug.nil?
      self.slug = neat_slug = title.downcase.parameterize
      self.slug = "#{neat_slug}-#{SecureRandom.urlsafe_base64 3}" while Post.where(slug: slug).exists? || slug.blank? || slug.downcase == 'new'
    end
  end
end
