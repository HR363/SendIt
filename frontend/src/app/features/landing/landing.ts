import { Component, OnInit, OnDestroy, NgZone, ChangeDetectorRef, AfterViewInit, ElementRef, Renderer2, Inject } from '@angular/core';
import { DOCUMENT } from '@angular/common';
import { NgForOf, NgClass } from '@angular/common';
import { RouterLink, RouterLinkWithHref } from '@angular/router';

interface Testimonial {
  name: string;
  avatar: string;
  text: string;
}

@Component({
  selector: 'app-landing',
  imports: [NgForOf, NgClass, RouterLink, RouterLinkWithHref],
  templateUrl: './landing.html',
  styleUrl: './landing.css'
})
export class Landing implements OnInit, OnDestroy, AfterViewInit {
  public Math = Math;
  testimonials: Testimonial[] = [
    {
      name: 'Alex M.',
      avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
      text: 'SendIt is a game-changer! The live tracking is incredibly accurate, and I get delivery updates in real time. A hassle-free delivery service I trust.'
    },
    {
      name: 'Sarah K.',
      avatar: 'https://randomuser.me/api/portraits/women/44.jpg',
      text: 'I love how easy it is to create an order and track my parcels. The notifications keep me updated every step of the way!'
    },
    {
      name: 'James L.',
      avatar: 'https://randomuser.me/api/portraits/men/65.jpg',
      text: 'The dashboard is super intuitive and the delivery is always on time. Highly recommended!'
    },
    {
      name: 'Priya S.',
      avatar: 'https://randomuser.me/api/portraits/women/68.jpg',
      text: 'SendIt made sending gifts to my family so much easier. The support team is also very responsive.'
    },
    {
      name: 'Carlos R.',
      avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
      text: 'Secure, fast, and reliable. I use SendIt for all my business deliveries now.'
    }
  ];
  position = 0; // px
  private animationId: number | null = null;
  cardWidth = 336; // w-80 + mx-2
  speed = 0.5; // px per frame (adjust for faster/slower river)
  private sectionObserver?: IntersectionObserver;
  private scrollListener?: () => void;

  constructor(
    private ngZone: NgZone,
    private cdr: ChangeDetectorRef,
    private renderer: Renderer2,
    private elRef: ElementRef,
    @Inject(DOCUMENT) private document: Document
  ) {}

  public ngOnInit(): void {
    this.startRiverFlow();
  }

  public ngAfterViewInit(): void {
    this.initSectionReveal();
    this.initParallax();
  }

  public ngOnDestroy(): void {
    this.stopRiverFlow();
    if (this.sectionObserver) {
      this.sectionObserver.disconnect();
    }
    if (this.scrollListener) {
      this.scrollListener();
    }
  }

  private initSectionReveal(): void {
    const sections: NodeListOf<HTMLElement> = this.document.querySelectorAll('.section-reveal');
    const options: IntersectionObserverInit = { threshold: 0.15 };
    this.sectionObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        const target = entry.target as HTMLElement;
        if (entry.isIntersecting) {
          target.classList.add('revealed');
        } else {
          target.classList.remove('revealed');
        }
      });
    }, options);
    sections.forEach(section => {
      section.classList.remove('revealed');
      this.sectionObserver!.observe(section);
    });
  }

  private initParallax(): void {
    this.ngZone.runOutsideAngular(() => {
      this.scrollListener = this.renderer.listen('window', 'scroll', () => {
        const scrollY: number = window.scrollY;
        // Parallax for hero parcel illustration
        const parcel = this.document.getElementById('hero-parcel');
        if (parcel) {
          this.renderer.setStyle(parcel, 'transform', `translateY(${scrollY * 0.12}px)`);
        }
        // Parallax for hero background shape
        const bg = this.document.getElementById('hero-bg-parallax');
        if (bg) {
          this.renderer.setStyle(bg, 'transform', `translateY(${scrollY * 0.18}px)`);
        }
      });
    });
  }

  private startRiverFlow(): void {
    this.stopRiverFlow();
    this.ngZone.runOutsideAngular(() => {
      const animate = () => {
        this.position += this.speed;
        const totalWidth = this.testimonials.length * this.cardWidth;
        if (this.position >= totalWidth) {
          this.position = 0;
        }
        this.cdr.detectChanges(); // Trigger change detection
        this.animationId = requestAnimationFrame(animate);
      };
      this.animationId = requestAnimationFrame(animate);
    });
  }

  private stopRiverFlow(): void {
    if (this.animationId !== null) {
      cancelAnimationFrame(this.animationId);
      this.animationId = null;
    }
  }

  get riverTransform(): string {
    return `translateX(-${this.position}px)`;
  }

  /**
   * Returns a class string for a card based on its distance from the center of the belt.
   * @param cardIndex The index of the card in the doubled array
   * @param totalCards The total number of unique cards
   * @returns string
   */
  getSpotlightClass(cardIndex: number, totalCards: number): string {
    // Center of the visible area (in px)
    const containerWidth = 1008; // 3 cards
    const centerPx = this.position + containerWidth / 2;
    // Center of this card (in px)
    const cardCenter = cardIndex * this.cardWidth + this.cardWidth / 2;
    // Distance from center (in card widths)
    const dist = Math.abs(cardCenter - centerPx) / this.cardWidth;
    // Spotlight: center card is fully visible, sides fade/scale
    const opacity = 1 - Math.min(dist, 1) * 0.5; // 1 at center, 0.5 at 1 card away
    const scale = 1 - Math.min(dist, 1) * 0.1;   // 1 at center, 0.9 at 1 card away
    return `scale-[${scale}] opacity-[${opacity}] z-10 transition-all duration-700`;
  }
}
