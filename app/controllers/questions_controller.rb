class QuestionsController < ApplicationController

	before_filter :load_data
	after_filter :save_data

	require "http"

	def final_quest
		###da cancellare###>>>>>>>>>>>>>>>>>>>>>>>>>>>>><
		@pois1=[]
		query="https://maps.googleapis.com/maps/api/place/photo?maxwidth=600" 
		@search.places_by_type.each do |type, places|
			places.each do |place|
				poi=Poi.new
				poi[:name]=place["name"]
				poi[:types]=type
				poi[:lat]=place["geometry"]["location"]["lat"]
				poi[:long]=place["geometry"]["location"]["lng"]
				poi[:price]=place["price_level"]
				poi[:rate]=place["rating"]
				poi[:address]=place["vicinity"]
				if(place["photos"]!=nil)
					id = place["photos"][0]["photo_reference"]					
					res_string= HTTP.get(query+"&photoreference="+id+"&key=AIzaSyBHJpb9fD5eBeN-wd0Xq0vYkTUtRSEgr0U").to_s
					res_string=res_string.split("HREF=\"")[1]
					res_string=res_string.split("\">here")[0]
					poi[:image]=res_string
				else
					poi[:image]="http://portfoliotheme.org/enigmatic/wp-content/uploads/sites/9/2012/07/placeholder1.jpg"
				end
				@pois1.push(poi)
			end
		end
	@pois1
###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	end

	def final_filter
		@pois= []
		query="https://maps.googleapis.com/maps/api/place/photo?maxwidth=600" 
		@search.places_by_type.each do |type, places|
			places.each do |place|
				if place["rating"].to_f < params[:rating].to_f
					places.delete(place)
				end
				if place["price"].to_f > params[:price].to_f
					places.delete(place)
				end
				if distanza(place["geometry"]["location"]["lat"].to_f,place["geometry"]["location"]["lng"].to_f) > params[:distance].to_f
					places.delete(place)
				end
			end
		end
		
		@search.places_by_type.each do |type, places|
			places.each do |place|
				poi=Poi.new
				poi[:name]=place["name"]
				poi[:types]=type
				poi[:lat]=place["geometry"]["location"]["lat"]
				poi[:long]=place["geometry"]["location"]["lng"]
				poi[:price]=place["price_level"]
				poi[:rate]=place["rating"]
				poi[:address]=place["vicinity"]
				if(place["photos"]!=nil)
					id = place["photos"][0]["photo_reference"]					
					res_string= HTTP.get(query+"&photoreference="+id+"&key=AIzaSyBHJpb9fD5eBeN-wd0Xq0vYkTUtRSEgr0U").to_s
					res_string=res_string.split("HREF=\"")[1]
					res_string=res_string.split("\">here")[0]
					poi[:image]=res_string
				else
					poi[:image]="http://portfoliotheme.org/enigmatic/wp-content/uploads/sites/9/2012/07/placeholder1.jpg"
				end
				@pois.push(poi)
			end
		end
	@pois
	end

	

	private
    def load_data
      @search = session[:search_object]
      @question = session[:question_object]
    end

    def save_data
      session[:search_object] = @search
      session[:question_object] = @question
    end

    def pitagora(x,y)
    	Math.sqrt((x ** 2) + (y ** 2))
    end

    def distanza2punti(x1,y1,x2,y2)
    	pitagora(x2-x1,y2-y1)
    end

    def distanza(x,y)
    	distanza2punti(request.location.latitude.to_f,
    					x,
    					request.location.longitude.to_f,
    					y)
    end
end
