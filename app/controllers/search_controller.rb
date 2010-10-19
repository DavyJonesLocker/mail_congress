class SearchController < InheritedResources::Base
  respond_to :html
  defaults :resource_class => Legislator, :collection_name => 'legislators', :instance_name => 'legislators'
  actions :show

  def show
    unless ((@legislators = Legislator.search(params[:search][:address])) && !@legislators.empty?)
      redirect_to root_path, :flash =>  { :notice => 'Please try your search again.' }
    end
  end
end
