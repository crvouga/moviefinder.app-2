// @ts-check

class ImageElement extends HTMLElement {
  constructor() {
    super();
    const shadow = this.attachShadow({ mode: "open" });

    const style = document.createElement("style");
    style.textContent = `
      .skeleton {
        width: 100%;
        height: 100%;
        animation: pulse 1.5s infinite ease-in-out;
        background-color: #323232;
      }

      @keyframes pulse {
        0% {
          opacity: 1;
        }
        50% {
          opacity: 0.8;
        }
        100% {
          opacity: 1;
        }
      }

      .image {
        display: none;
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    `;

    this.skeleton = document.createElement("div");
    this.skeleton.className = "skeleton";

    this.image = document.createElement("img");
    this.image.className = "image";
    this.image.alt = this.getAttribute("alt") || "";

    shadow.appendChild(style);
    shadow.appendChild(this.skeleton);
    shadow.appendChild(this.image);

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          this.loadImage();
          this.observer.disconnect();
        }
      });
    });
  }

  connectedCallback() {
    this.observer.observe(this);
  }

  disconnectedCallback() {
    this.observer.disconnect();
  }

  loadImage() {
    this.image.src = this.getAttribute("src") ?? "";
    this.image.addEventListener("load", () => this.onImageLoaded());
  }

  onImageLoaded() {
    this.skeleton.style.display = "none";
    this.image.style.display = "block";
  }
}

customElements.define("image-element", ImageElement);
