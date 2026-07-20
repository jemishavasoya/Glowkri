document.addEventListener('DOMContentLoaded', () => {
    const copyBtn = document.getElementById('copyBtn');
    const codeText = document.getElementById('codeText');

    copyBtn.addEventListener('click', async () => {
        try {
            await navigator.clipboard.writeText(codeText.innerText);
            
            // Visual feedback
            const originalHTML = copyBtn.innerHTML;
            copyBtn.innerHTML = `
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                <span>Copied!</span>
            `;
            copyBtn.classList.add('copied');

            // Reset after 2 seconds
            setTimeout(() => {
                copyBtn.innerHTML = originalHTML;
                copyBtn.classList.remove('copied');
            }, 2000);
        } catch (err) {
            console.error('Failed to copy text: ', err);
            copyBtn.innerHTML = `<span>Failed</span>`;
            setTimeout(() => {
                copyBtn.innerHTML = `
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
                    <span>Copy</span>
                `;
            }, 2000);
        }
    });

    // Add subtle parallax effect to the demo image
    const demoImage = document.querySelector('.demo-image');
    if (demoImage) {
        document.addEventListener('mousemove', (e) => {
            const xAxis = (window.innerWidth / 2 - e.pageX) / 50;
            const yAxis = (window.innerHeight / 2 - e.pageY) / 50;
            demoImage.style.transform = `rotateY(${xAxis}deg) rotateX(${yAxis}deg) scale(1.02)`;
        });
        
        // Reset on mouse leave
        document.addEventListener('mouseleave', () => {
            demoImage.style.transform = `rotateY(0deg) rotateX(0deg) scale(1)`;
        });
    }
});
