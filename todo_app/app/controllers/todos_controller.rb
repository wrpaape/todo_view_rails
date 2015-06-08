class TodosController < ApplicationController

  def index
    begin
      if params[:id] || params[:body] || params[:completed]
        todo_match = Todo.new
        response, response_code = todo_match.get(params)
      else
        response_code = "200"
        response = Todo.all
      end
      respond_to do |format|
        format.html { render "index.html.erb", locals: { todos: response }, status: response_code }
        format.json { render_json(todos, response_code) }
      end
      rescue ActiveRecord::RecordNotFound => error
        render_json(error.message, 404)
      rescue StandardError => error
        render_json(error.message, 422)
    end
  end

  def new
    begin
      response_code = "200"
      response = Todo.create

      respond_to do |format|
        format.html { render_html("new.html.erb", response, response_code) }

        format.json { render_json(response, response_code) }
      end
    rescue ActiveRecord::RecordNotFound => error
      render_json(error.message, 404)
    rescue StandardError => error
      render_json(error.message, 422)
    end
  end

  def create
    begin
      response_code = "200"
      response = Todo.create(body: params[:body])

      respond_to do |format|
        format.html { render_html("create.html.erb", response, response_code) }
        format.json { render_json(response, response_code) }
      end
    rescue ActiveRecord::RecordNotFound => error
      render_json(error.message, 404)
    rescue StandardError => error
      render_json(error.message, 422)
    end
  end

  def show
    begin
      todo_match = Todo.new
      response, response_code = todo_match.get(params)

      respond_to do |format|
        format.html { render_html("show.html.erb", response, response_code) }
        format.json { render_json(response, response_code) }
      end
    rescue ActiveRecord::RecordNotFound => error
      render_json(error.message, 404)
    rescue StandardError => error
      render_json(error.message, 422)
    end
  end

  # def show
  #   found_student = Student.find(params[:id])
  #   respond_to do |format|
  #     format.html do
  #       render 'show.html.erb', locals: { student: found_student }
  #     end
  #     format.json do
  #       render json: found_student
  #     end
  #   end
  # end



  def update
    begin
      todo = Todo.find(params[:id])
      todo.completed = params[:completed] if params[:completed]
      todo.body = params[:body] if params[:body]
      todo.save
      render_json(todo, 200)
    rescue ActiveRecord::RecordNotFound => error
      render_json(error.message, 404)
    rescue StandardError => error
      render_json(error.message, 422)
    end
  end

  def destroy
    begin
      todo = Todo.find(params[:id])
      todo.destroy
      render_json("deleted", 200)
    rescue ActiveRecord::RecordNotFound => error
      render_json(error.message, 404)
    rescue StandardError => error
      render_json(error.message, 422)
    end
  end


  def not_found
    response = []
    response_code = 404
    response << "-" * 50
    response << "Not Found LOL"
    response << "-" * 50
    response << "Response Code: #{response_code}"
    response << "-" * 50
    response = response.join("<p>")
    render_json(response, response_code)
  end

  private

  def render_html(file, response, response_code)
    render file, locals: { todo: response }, status: response_code
  end

  def render_json(response, response_code)
    render json: response, status: response_code
  end
end
