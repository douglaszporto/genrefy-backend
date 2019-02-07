class ArtistsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def build_artists

        last_id = ""
        num_artists = 0
        pages = 1
        current_page = 0
        items_by_page = 50
        last_id_param = ""
        artists_user = []

        # Obtem os dados do usuario
        req = RestClient.get("https://api.spotify.com/v1/me", {
            accept: :json,
            Authorization: 'Bearer ' + params[:token] 
        })
        
        res = JSON.parse req.body

        exists_user = User.where(spotify_id: res["id"]).take

        if !exists_user
            exists_user = User.new(
                :name => res["display_name"],
                :spotify_id => res["id"]
            )

            exists_user.save!
        end


        # Obtem os dados dos artistas
        while(current_page < pages)
            last_id_param = '&after=' + last_id
            
            req = RestClient.get("https://api.spotify.com/v1/me/following?type=artist&limit=#{items_by_page}" + (last_id != '' ? last_id_param : ''), {
                accept: :json,
                Authorization: 'Bearer ' + params[:token] 
            })
            
            res = JSON.parse req.body
            
            res["artists"]["items"].each do |artist|
                last_id = artist["id"]
                #puts "#{num_artists} -> " + artist["name"]

                exists_artists = Artist.where(spotify_id: artist["id"]).take

                if !exists_artists
                    new_artist = Artist.new(
                        :href => artist["href"],
                        :spotify_id => artist["id"],
                        :name => artist["name"],
                        :popularity => artist["popularity"],
                        :uri => artist["uri"],
                        :external_urls => artist["external_urls"]["spotify"],
                        :followers => artist["followers"]["total"]
                    )

                    new_artist.save!

                    artist["images"].each do |img|
                        new_image = Image.new(
                            :url => img["url"],
                            :width => img["width"].to_i,
                            :height => img["height"].to_i,
                            :artist_id => new_artist.id
                        )
                        new_image.save!
                        puts new_image.inspect
                    end


                    array_genres = []
                    artist["genres"].each do |genre|
                        new_genre = Genre.where(name: genre).take

                        if !new_genre
                            new_genre = Genre.new(
                                :name => genre
                            )
                            new_genre.save!
                        end

                        array_genres.push(new_genre)
                    end
                    new_artist.genres << array_genres

                    artists_user.push(new_artist)
                end

                num_artists += 1
            end

            pages = (res["artists"]["total"].to_f / items_by_page).ceil
            current_page += 1
        end

        if artists_user.length > 0
            exists_user.artists << artists_user
        end

        render :json => {
            :user => exists_user.spotify_id
        }
    end

    def get_artists
        user = User.where(spotify_id: params[:user]).take

        if user == nil
            render :json => {
                :error => "Usuário não cadastrado"
            }
            return
        end

        artists = Artist.joins(:users).where(:users => {:id => user.id})

        result_artists = []
        result_genres = {}
        art = nil
        gen = nil

        artists.each do |artist|
            art = {}

            artist.attributes.each do |prop, val|
                art[prop] = val
            end

            gen = Genre.joins(:artists).where(:artists => {:id => artist.id}).find_each

            art["genres"] = []
            gen.each do |genre|
                art["genres"].push(genre.id)

                if !result_genres.key?(genre.id)
                    result_genres[genre.id] = genre
                end
            end



            img = Image.where(:artist_id => artist.id).find_each

            art["images"] = img
            #img.each do |image|
            #    art["images"].push(image.id)

                #if !result_genres.key?(genre.id)
                    #result_genres[genre.id] = genre
                #end
            #end


            result_artists.push(art)
        end

        render :json => {
            artists: result_artists,
            genres: result_genres
        }
    end
end
