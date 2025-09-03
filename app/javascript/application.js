import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "bootstrap"

import "trix"
import "@rails/actiontext"

document.addEventListener('turbo:load', () => {
  const toastElList = [].slice.call(document.querySelectorAll('.toast'));
  toastElList.forEach((toastEl) => {
    const toast = new bootstrap.Toast(toastEl);
    toast.show();

    toastEl.addEventListener('hidden.bs.toast', () => {
      toastEl.remove();
    });
  });
});

document.addEventListener('turbo:before-render', () => {
  const toastContainer = document.querySelector('.toast-container');
  if (toastContainer) {
    toastContainer.remove(); 
  }
});


