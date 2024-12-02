module TasksHelper
  def category_image(task)
   

    case task.task_category
    when 'Electrical'
      case task.status
      when 'pending'
        image_path('eleccardorange.png')
      when 'accepted'
        image_path('eleccardblue.png')
      when 'completed'
        image_path('eleccardgold.png')
      else
        image_path('logo.png') # fallback
      end
    when 'Plumbing'
      case task.status
      when 'pending'
        image_path('plumbingcardorange.png')
      when 'accepted'
        image_path('plumbingcardblue.png')
      when 'completed'
        image_path('plumbingcardgold.png')
      else
        image_path('logo.png') # fallback
      end
    when 'Decorating'
      case task.status
      when 'pending'
        image_path('deccardorange.png')
      when 'accepted'
        image_path('deccardblue.png')
      when 'completed'
        image_path('deccardgold.png')
      else
        image_path('logo.png') # fallback
      end
    when 'Gardening'
      case task.status
      when 'pending'
        image_path('gardcardorange.png')
      when 'accepted'
        image_path('gardcardblue.png')
      when 'completed'
        image_path('gardcardgold.png')
      else
        image_path('logo.png') # fallback
      end
    else
      image_path('logo.png') # default fallback
    end
  end
end
