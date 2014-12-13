class MemesController < ApplicationController
  before_action :set_meme, only: [:show, :edit, :update, :destroy]

  # GET /memes
  # GET /memes.json
  def index
    @memes = Meme.all
  end

  def query
    @memes = []
    start = params[:s].to_i
    count = params[:c].to_i
    query = params[:q].to_s.split(/\W+/).sort.uniq

    @memes_all = Meme.all
    @memes = []

    
    @memes_all.each do |meme|
      t = meme.tags
      @words = t.split(/\W+/)
      is_good = 0
      query.each do |q|
        @words.each do |word|
          if q == word
            is_good = is_good + 1
          end
        end
      end 
      if is_good > 0
        @memes << {:meme => meme, :cnt => is_good }
      end
    end

    @memes.sort! do |a,b|
      case 
      when a[:cnt].to_i < b[:cnt].to_i
        1
      when a[:cnt].to_i > b[:cnt].to_i
        -1
      else
        a[:meme].likes_count.to_i <=> b[:meme].likes_count.to_i
      end

    end

    #in plus
    @v = []
    cnt = 0
    @memes.each do |m|
      cnt = cnt + 1
      if cnt >= start && cnt <= start + count - 1 
        @v << m[:cnt]
      end
    end
    @cnt = @v
    #in plus 
    @v = []
    cnt = 0
    @memes.each do |m|
      cnt = cnt + 1
      if cnt >= start && cnt <= start + count - 1 
        @v << m[:meme]
      end
    end
    @memes = @v


  

  end

  def incr
  end

  def favs
  end

  def tag
    start = params[:s].to_i
    count = params[:c].to_i
    @memes = Meme.all
    tags_uniq = []
    tags_num = []

     #puts words

    @tags = []

    @words = []
    @memes.each do |meme|
      t = meme.tags
      if t!= nil
        t.split(/\W+/).each do |str|
          @words << str
       end
      end
    end

    tags_uniq = @words.sort.uniq
    k = 0
    cnt = 0

    tags_uniq.each do |tag|
      k = 0
      @words.each do |word|
        if word == tag
          k = k+1
        end
      end
      cnt = cnt + 1
      if cnt >= start && cnt <= start + count - 1
        tags_num << k
        @tags << {:tag => tag, :popularity => k }
      end
    end

    @tags.sort! do |a,b|
      case 
      when a[:popularity].to_i < b[:popularity].to_i
        1
      when a[:popularity].to_i > b[:popularity].to_i
        -1
      else
        0
      end

    end

    @tags

  end

  # GET /memes/1
  # GET /memes/1.json
  def show
  end

  # GET /memes/new
  def new
    @meme = Meme.new
  end

  # GET /memes/1/edit
  def edit
  end

  # POST /memes
  # POST /memes.json
  def create
    title = meme_params[:title]
    url = meme_params[:url]
    author = meme_params[:author]
    tags = meme_params[:tags]
    copy_count = req_count = likes_count = favs_count = 0
    @meme = Meme.new({:title => title,
                      :url => url,
                      :author => author,
                      :tags => tags,
                      :copy_count => copy_count,
                      :favs_count => favs_count,
                      :req_count => req_count,
                      :likes_count => likes_count})

    respond_to do |format|
      if @meme.save
        format.html { redirect_to @meme, notice: 'Meme was successfully created.' }
        format.json { render :show, status: :created, location: @meme }
      else
        format.html { render :new }
        format.json { render json: @meme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memes/1
  # PATCH/PUT /memes/1.json
  def update
    respond_to do |format|
      if @meme.update(meme_params)
        format.html { redirect_to @meme, notice: 'Meme was successfully updated.' }
        format.json { render :show, status: :ok, location: @meme }
      else
        format.html { render :edit }
        format.json { render json: @meme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memes/1
  # DELETE /memes/1.json
  def destroy
    @meme.destroy
    respond_to do |format|
      format.html { redirect_to memes_url, notice: 'Meme was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meme
      @meme = Meme.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meme_params
      params.require(:meme).permit(:url, :author, :copy_count, :title, :tags, :likes_count, :favs_count, :req_count)
    end
end
