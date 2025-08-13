// Main JavaScript for Hà Tĩnh Runners Website

document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Header scroll effect
    const header = document.getElementById('header');
    let lastScrollTop = 0;

    window.addEventListener('scroll', function() {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        if (scrollTop > 100) {
            header.style.background = 'rgba(124, 156, 191, 0.95)';
            header.style.backdropFilter = 'blur(20px)';
        } else {
            header.style.background = 'linear-gradient(135deg, #7c9cbf 0%, #ff8a5c 100%)';
            header.style.backdropFilter = 'blur(10px)';
        }
        
        lastScrollTop = scrollTop;
    });

    // Animate elements on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe all cards and sections
    document.querySelectorAll('.post-card, .featured-card, .running-stats, .archive-header, .tag-header').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // Enhanced button interactions
    document.querySelectorAll('.btn, .share-btn').forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-3px) scale(1.02)';
        });
        
        button.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });

    // Add loading state to forms (if any)
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function() {
            const submitBtn = this.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.classList.add('loading');
                submitBtn.textContent = 'Đang xử lý...';
            }
        });
    });

    // Enhanced image loading
    document.querySelectorAll('img').forEach(img => {
        img.addEventListener('load', function() {
            this.style.opacity = '1';
        });
        
        img.style.opacity = '0';
        img.style.transition = 'opacity 0.3s ease';
    });

    // Add running pace indicators to relevant content
    addPaceIndicators();
});

// Function to add pace indicators to running-related content
function addPaceIndicators() {
    const paceKeywords = {
        'easy': 'easy',
        'moderate': 'medium',
        'hard': 'fast',
        'tempo': 'fast',
        'interval': 'fast',
        'long run': 'medium'
    };

    document.querySelectorAll('p, h1, h2, h3').forEach(element => {
        const text = element.textContent.toLowerCase();
        
        for (const [keyword, pace] of Object.entries(paceKeywords)) {
            if (text.includes(keyword)) {
                const indicator = document.createElement('span');
                indicator.className = `pace-indicator ${pace}`;
                indicator.innerHTML = `<i class="bi bi-speedometer2"></i> ${pace} pace`;
                element.appendChild(indicator);
                break;
            }
        }
    });
}

// Add some running-themed console messages
console.log('🏃‍♂️ Hà Tĩnh Runners - Ready to run!');
console.log('💪 Keep pushing your limits!');
console.log('🌟 Every step counts towards your goals!');
