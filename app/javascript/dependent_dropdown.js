// app/javascript/dependent_dropdown.js

document.addEventListener("turbo:load", function() {
    const categorySelect = document.querySelector('[data-behavior="category-select"]');
    const taskTypeSelect = document.querySelector('[data-behavior="task-type-select"]');
  
    // Define task types for each category
    const taskTypes = {
      'Electrical': ['Change bulb', 'Fix switch', 'Install wiring'],
      'Plumbing': ['Fix leak', 'Install faucet', 'Clear drain'],
      'Gardening': ['Plant flowers', 'Trim hedge', 'Mow lawn'],
      'Decorating': ['Paint wall', 'Hang picture', 'Arrange furniture']
    };
  
    categorySelect.addEventListener("change", function() {
      const selectedCategory = categorySelect.value;
  
      // Clear the task_type options
      taskTypeSelect.innerHTML = '';
  
      // Add the prompt option
      const promptOption = document.createElement('option');
      promptOption.text = 'Select Task Type';
      promptOption.value = '';
      taskTypeSelect.add(promptOption);
  
      // Populate task_type based on the selected category
      if (taskTypes[selectedCategory]) {
        taskTypes[selectedCategory].forEach(function(task) {
          const option = document.createElement('option');
          option.text = task;
          option.value = task;
          taskTypeSelect.add(option);
        });
      }
    });
  });
  