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
      maxColumns: 3, // Maximum 3 columns
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
});
