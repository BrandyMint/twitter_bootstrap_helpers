$(function(){
  // Переключает вкладки через кнопки в btn-group
  $('.tabbable .btn-group button').click(function(){
    $(this).tab('show');
  });
});
