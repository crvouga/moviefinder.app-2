class SkeletonImage extends HTMLElement {
  constructor() {
    super();
    const shadow = this.attachShadow({ mode: `open` });

    const style = document.createElement(`style`);
    style.textContent = `
      .skeleton {
        width: 100%;
        height: 100%;
        background-color: #e0e0e0;
        border-radius: 8px;
        animation: pulse 1.5s infinite ease-in-out;
      }

      @keyframes pulse {
        0% {
          background-color: #e0e0e0;
        }
        50% {
          background-color: #f0f0f0;
        }
        100% {
          background-color: #e0e0e0;
        }
      }

      .image {
        display: none;
        width: 100%;
        height: auto;
        border-radius: 8px;
      }
    `;

    this.skeleton = document.createElement(`div`);
    this.skeleton.className = `skeleton`;

    this.image = document.createElement(`img`);
    this.image.className = `image`;
    this.image.alt = this.getAttribute(`alt`) || ``;

    shadow.appendChild(style);
    shadow.appendChild(this.skeleton);
    shadow.appendChild(this.image);
  }

  connectedCallback() {
    this.image.src = this.getAttribute(`src`);
    this.image.addEventListener(`load`, () => this.onImageLoaded());
  }

  disconnectedCallback() {
    this.image.removeEventListener(`load`, () => this.onImageLoaded());
  }

  onImageLoaded() {
    this.skeleton.style.display = `none`;
    this.image.style.display = `block`;
  }
}

customElements.define(`skeleton-image`, SkeletonImage);
