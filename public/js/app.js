console.log("hello world")

// Initialize Magic Grid for repository cards
document.addEventListener('DOMContentLoaded', function() {
  const gridContainer = document.getElementById('magic-grid');
  
  if (gridContainer) {
    const magicGrid = new MagicGrid({
      container: '#magic-grid',
      static: true, // Since repo cards are rendered server-side
      animate: true,
      gutter: 24, // 24px gap between cards
      maxColumns: 4, // Maximum 4 columns
      useMin: true, // Prioritize shorter columns
      center: true // Center the grid
    });

    // Initialize the grid
    magicGrid.listen();

    // Optional: Log when grid is ready
    magicGrid.onReady(() => {
      console.log("Magic Grid initialized");
    });
  }

  // Add hover effects for title links (fallback for browsers without :has() support)
  const titleLinks = document.querySelectorAll('.repo-card h3 a');
  titleLinks.forEach(link => {
    link.addEventListener('mouseenter', function() {
      const card = this.closest('.repo-card');
      card.classList.add('card-hover');
    });
    
    link.addEventListener('mouseleave', function() {
      const card = this.closest('.repo-card');
      card.classList.remove('card-hover');
    });
  });
});
