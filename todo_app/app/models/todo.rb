class Todo < ActiveRecord::Base
  def get(params)
    response_code = "200"
    id, completed, body = [params[:id], params[:completed], params[:body]]

    if id
      response = Todo.find(id)
    else
      if completed.nil?
        response = Todo.where(body: body)
      elsif body
        response = Todo.where(body: body, completed: to_boolean(completed))
      else
        response = Todo.where(completed: to_boolean(completed))
      end
      response = response.first if response.size == 1
    end
    [response, response_code]
  end

  def to_boolean(str)
    str == 'true'
  end
end
