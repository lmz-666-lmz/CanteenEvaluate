/**
 * 山海寻味录 — Modern App JavaScript v3.0
 * Vanilla JS utilities: Toast, Modal, Confirm, AJAX helpers
 * No jQuery dependency — pure ES5+ compatible
 */

// =========================================================================
// Toast Notifications
// =========================================================================
var ModernToast = {
  show: function (message, type) {
    type = type || 'info';
    var icons = {
      success: '✓',
      error: '✕',
      warning: '⚠',
      info: 'ℹ'
    };
    var icon = icons[type] || icons.info;

    var toast = document.createElement('div');
    toast.className = 'modern-toast ' + type;
    toast.innerHTML = '<strong>' + icon + '</strong> ' + message;
    document.body.appendChild(toast);

    setTimeout(function () {
      toast.classList.add('toast-removing');
      setTimeout(function () {
        if (toast.parentNode) toast.parentNode.removeChild(toast);
      }, 300);
    }, 3800);
  }
};

// =========================================================================
// Confirm Dialog (replaces native confirm() with styled modal)
// =========================================================================
function showConfirm(message, onConfirm) {
  var overlay = document.createElement('div');
  overlay.className = 'modal-overlay active';
  overlay.id = '__confirmDialog';

  overlay.innerHTML =
    '<div class="modal-dialog">' +
    '<div class="modal-dialog-header">' +
    '<h3>确认操作</h3>' +
    '<button class="modal-dialog-close" id="__confirmClose">×</button>' +
    '</div>' +
    '<div class="modal-dialog-body">' +
    '<p>' + message + '</p>' +
    '</div>' +
    '<div class="modal-dialog-footer">' +
    '<button class="btn btn-outline btn-sm" id="__confirmCancel">取消</button>' +
    '<button class="btn btn-danger btn-sm" id="__confirmOk">确认删除</button>' +
    '</div>' +
    '</div>';

  document.body.appendChild(overlay);
  document.body.style.overflow = 'hidden';

  function close() {
    overlay.classList.remove('active');
    document.body.style.overflow = '';
    setTimeout(function () {
      if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
    }, 200);
  }

  document.getElementById('__confirmClose').onclick = close;
  document.getElementById('__confirmCancel').onclick = close;
  overlay.addEventListener('click', function (e) {
    if (e.target === overlay) close();
  });

  document.getElementById('__confirmOk').onclick = function () {
    close();
    if (typeof onConfirm === 'function') onConfirm();
  };

  // Close on Escape
  function onKey(e) {
    if (e.key === 'Escape') {
      close();
      document.removeEventListener('keydown', onKey);
    }
  }
  document.addEventListener('keydown', onKey);
}

// =========================================================================
// AJAX Helpers (replaces jQuery $.post / $.ajax)
// =========================================================================
var ModernHttp = {
  /**
   * POST request with URL-encoded form data
   * Usage: ModernHttp.post('/path', { key: 'val' }, function(err, text) { ... })
   */
  post: function (url, data, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status >= 200 && xhr.status < 300) {
          callback(null, xhr.responseText);
        } else {
          callback(new Error('HTTP ' + xhr.status), xhr.responseText);
        }
      }
    };
    var params = [];
    for (var key in data) {
      if (data.hasOwnProperty(key)) {
        params.push(encodeURIComponent(key) + '=' + encodeURIComponent(data[key]));
      }
    }
    xhr.send(params.join('&'));
  },

  /**
   * GET request
   */
  get: function (url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status >= 200 && xhr.status < 300) {
          callback(null, xhr.responseText);
        } else {
          callback(new Error('HTTP ' + xhr.status), xhr.responseText);
        }
      }
    };
    xhr.send();
  }
};

// =========================================================================
// Form Helpers
// =========================================================================
var ModernForm = {
  /**
   * Serialize a form to a URL-encoded string or plain object
   */
  serialize: function (formEl) {
    var data = {};
    var inputs = formEl.querySelectorAll('input, select, textarea');
    for (var i = 0; i < inputs.length; i++) {
      var el = inputs[i];
      if (el.name && !el.disabled) {
        data[el.name] = el.value;
      }
    }
    return data;
  }
};

// =========================================================================
// DOM Ready helper
// =========================================================================
function onReady(fn) {
  if (document.readyState !== 'loading') {
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
}

// =========================================================================
// Auto-initialize on page load
// =========================================================================
onReady(function () {
  // Auto-dismiss alerts after 4 seconds (add class "alert-auto" to enable)
  var alerts = document.querySelectorAll('.alert-auto');
  alerts.forEach(function (alert) {
    setTimeout(function () {
      alert.style.opacity = '0';
      alert.style.transform = 'translateY(-8px)';
      alert.style.transition = 'all 0.4s ease';
      setTimeout(function () {
        if (alert.parentNode) alert.parentNode.removeChild(alert);
      }, 400);
    }, 4000);
  });

  // Close modals on overlay click
  document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay') && e.target.classList.contains('active')) {
      e.target.classList.remove('active');
      document.body.style.overflow = '';
    }
  });

  // Close modals on Escape
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
      var openModals = document.querySelectorAll('.modal-overlay.active');
      openModals.forEach(function (m) {
        m.classList.remove('active');
      });
      document.body.style.overflow = '';
    }
  });
});
