class MemesController < ActionController::Base
  before_action :set_meme, only: [:show, :edit, :update, :destroy]

  # GET /memes
  # GET /memes.json
  def index
    @memes = Meme.all
  end

=begin
  def match(a, b)
    a = a.to_s.downcase
    b = b.to_s.downcase
    if a == b || (a.include?(b) ==true && (a.length - b.length) <= 3 )  || (b.include?(a)==true && (b.length - a.length) <= 3) 
      result = 1
    else
      result = 0
    end
    result
  end
=end

  def match(a, b)
    a = a.to_s.downcase
    b = b.to_s.downcase
    result = 0
    if a == b 
      return 100
    end
    if (a.include?(b) ==true && (a.length - b.length) ==1 )  || (b.include?(a)==true && (b.length - a.length) ==1) 
      return 50
    end
    if (a.length >=3 && a.include?(b) ==true && (a.length - b.length) ==2 )  || (b.length >=3 && b.include?(a)==true && (b.length - a.length) ==2) 
      return 25
    end
    if (a.length >=6 && a.include?(b) ==true && (a.length - b.length) == 3 )  || (b.length >=6 && b.include?(a)==true && (b.length - a.length) ==3) 
      return 15
    end
    return 0
  end


  def query
    @memes = []
    start = params[:s].to_i
    count = params[:c].to_i
    query = params[:q]

    @memes_all = Meme.all
    @memes = []

    if valid(query) == 1
      query = params[:q].to_s.split(/\W+/).sort.uniq
      @memes_all.each do |meme|
        t = meme.tags
        @words = t.split(/\W+/)
        is_good = 0
        query.each do |q|
          @words.each do |word|
              is_good += match(q,word)
          end
        end 
        if is_good > 0
          @memes << {:meme => meme, :cnt => is_good }
        end
      end
    else
      @memes_all.each do |meme|
        @memes << {:meme => meme, :cnt => 1 }
      end
    end  
    @memes.sort! do |a,b|
      case 
      when a[:cnt].to_i < b[:cnt].to_i
        1
      when a[:cnt].to_i > b[:cnt].to_i
        -1
      else
        b[:meme].copy_count.to_i <=> a[:meme].copy_count.to_i 
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

  def valid(input)
    if input != nil && input.to_s != ''
      1
    else
      0
    end
  end

  def incr
    meme_id = params[:mid]
    if valid(meme_id) == 1
      @meme = Meme.find_by({:id => meme_id.to_i} )
      if @meme != nil
        cnt = @meme.copy_count  + 1
        @meme.update({:copy_count => cnt})
        @meme.save 
      end
    end
    render :json => {:executed => "OK"}
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
    @tags2 = []

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
      tags_num << k
      @tags2 << {:tag => tag, :popularity => k }
    end

    @tags2.sort! do |a,b|
      case 
      when a[:popularity].to_i < b[:popularity].to_i
        1
      when a[:popularity].to_i > b[:popularity].to_i
        -1
      else
        0
      end
    end

    if count > 0
      cnt = start
      while cnt <= start + count - 1
        @tags << @tags2[cnt]
        cnt = cnt + 1
      end
    else
      @tags = @tags2
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
