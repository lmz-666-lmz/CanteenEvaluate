/**
 * Admin Modern — Shared Utilities
 * 山海寻味录 · 管理员后台
 */

// ---- Modal Helpers ----
const AdminModal = {
  open: function (id) {
    const el = document.getElementById(id);
    if (el) {
      el.classList.add('active');
      document.body.style.overflow = 'hidden';
      // Focus trap
      setTimeout(function () {
        var firstInput = el.querySelector('input:not([type="hidden"]), button');
        if (firstInput) firstInput.focus();
      }, 100);
    }
  },

  close: function (id) {
    const el = document.getElementById(id);
    if (el) {
      el.classList.remove('active');
      document.body.style.overflow = '';
    }
  },

  closeAll: function () {
    document.querySelectorAll('.modal-overlay.active').forEach(function (m) {
      m.classList.remove('active');
    });
    document.body.style.overflow = '';
  }
};

// Close modal on overlay click
document.addEventListener('click', function (e) {
  if (e.target.classList.contains('modal-overlay') && e.target.classList.contains('active')) {
    AdminModal.close(e.target.id);
  }
});

// Close modal on Escape key
document.addEventListener('keydown', function (e) {
  if (e.key === 'Escape') {
    AdminModal.closeAll();
  }
});

// ---- Toast Notifications ----
const Toast = {
  show: function (message, type) {
    type = type || 'info';
    var colors = {
      success: { bg: '#ECFDF5', border: '#A7F3D0', text: '#065F46', icon: '✓' },
      error: { bg: '#FEF2F2', border: '#FECACA', text: '#991B1B', icon: '✕' },
      warning: { bg: '#FFFBEB', border: '#FDE68A', text: '#92400E', icon: '!' },
      info: { bg: '#EFF6FF', border: '#BFDBFE', text: '#1E40AF', icon: 'ℹ' }
    };
    var c = colors[type] || colors.info;

    var toast = document.createElement('div');
    toast.style.cssText =
      'position:fixed;top:20px;right:20px;z-index:9999;' +
      'padding:14px 20px;border-radius:10px;font-size:14px;font-weight:500;' +
      'display:flex;align-items:center;gap:10px;' +
      'box-shadow:0 10px 25px rgba(0,0,0,0.1);' +
      'animation:slideIn 0.3s ease;' +
      'max-width:420px;' +
      'background:' + c.bg + ';border:1px solid ' + c.border + ';color:' + c.text;
    toast.innerHTML = '<span style="font-weight:700;font-size:16px;">' + c.icon + '</span> ' + message;

    document.body.appendChild(toast);

    setTimeout(function () {
      toast.style.opacity = '0';
      toast.style.transform = 'translateX(20px)';
      toast.style.transition = 'all 0.3s ease';
      setTimeout(function () {
        if (toast.parentNode) toast.parentNode.removeChild(toast);
      }, 300);
    }, 3500);
  }
};

// ---- Confirm Dialog (nicer than native confirm) ----
function showConfirm(message, onConfirm) {
  var overlay = document.createElement('div');
  overlay.className = 'modal-overlay active';
  overlay.id = 'confirmDialog';
  overlay.innerHTML =
    '<div class="modal" style="width:400px;">' +
    '<div class="modal-header">' +
    '<h3>确认操作</h3>' +
    '<button class="modal-close" onclick="AdminModal.close(\'confirmDialog\')">×</button>' +
    '</div>' +
    '<div class="modal-body">' +
    '<p style="font-size:15px;color:var(--color-text);line-height:1.6;">' + message + '</p>' +
    '</div>' +
    '<div class="modal-footer">' +
    '<button class="btn btn-outline" onclick="AdminModal.close(\'confirmDialog\')">取消</button>' +
    '<button class="btn btn-danger" id="confirmOk">确认</button>' +
    '</div>' +
    '</div>';

  document.body.appendChild(overlay);
  document.body.style.overflow = 'hidden';

  document.getElementById('confirmOk').onclick = function () {
    AdminModal.close('confirmDialog');
    if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
    document.body.style.overflow = '';
    if (typeof onConfirm === 'function') onConfirm();
  };
}

// ---- Auto-dismiss alerts ----
document.addEventListener('DOMContentLoaded', function () {
  var alerts = document.querySelectorAll('.alert:not(.alert-persist)');
  alerts.forEach(function (alert) {
    setTimeout(function () {
      alert.style.opacity = '0';
      alert.style.transform = 'translateY(-5px)';
      alert.style.transition = 'all 0.4s ease';
      setTimeout(function () {
        if (alert.parentNode) alert.parentNode.removeChild(alert);
      }, 400);
    }, 4000);
  });

  // Highlight active sidebar link
  var currentPath = window.location.pathname;
  var navLinks = document.querySelectorAll('.sidebar-nav a');
  navLinks.forEach(function (link) {
    if (currentPath.indexOf(link.getAttribute('data-page')) !== -1) {
      link.classList.add('active');
    }
  });
});
